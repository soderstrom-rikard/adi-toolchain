/* Blackfin GUI (SDL) helper code

   Copyright (C) 2010 Free Software Foundation, Inc.
   Contributed by Analog Devices, Inc.

   This file is part of simulators.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

#include "config.h"

#ifdef HAVE_SDL
# include <SDL.h>
#endif
#ifdef HAVE_DLFCN_H
# include <dlfcn.h>
#endif

#include "libiberty.h"
#include "gui.h"

#ifdef HAVE_SDL

static struct {
  void *handle;
  int (*Init) (Uint32 flags);
  void (*Quit) (void);
  SDL_Surface *(*SetVideoMode) (int width, int height, int bpp, Uint32 flags);
  void (*WM_SetCaption) (const char *title, const char *icon);
  int (*ShowCursor) (int toggle);
  int (*LockSurface) (SDL_Surface *surface);
  void (*UnlockSurface) (SDL_Surface *surface);
  Uint32 (*MapRGB) (const SDL_PixelFormat * const format, const Uint8 r, const Uint8 g, const Uint8 b);
  void (*UpdateRect) (SDL_Surface *screen, Sint32 x, Sint32 y, Uint32 w, Uint32 h);
} sdl;

static const char * const sdl_syms[] = {
  "SDL_Init",
  "SDL_Quit",
  "SDL_SetVideoMode",
  "SDL_WM_SetCaption",
  "SDL_ShowCursor",
  "SDL_LockSurface",
  "SDL_UnlockSurface",
  "SDL_MapRGB",
  "SDL_UpdateRect",
};

struct gui_state {
  SDL_Surface *screen;
  int throttle, throttle_limit;
  int bpp, curr_line;
};

void *
bfin_gui_setup (void *state, int enabled, int width, int height, int bpp)
{
  /* Load the SDL lib on the fly to avoid hard linking against it.  */
  if (sdl.handle == NULL)
    {
      int i;
      uintptr_t **funcs;

      sdl.handle = dlopen ("libSDL-1.2.so.0", RTLD_LAZY);
      if (sdl.handle == NULL)
	return NULL;

      funcs = (void *) &sdl.Init;
      for (i = 0; i < ARRAY_SIZE (sdl_syms); ++i)
	{
	  funcs[i] = dlsym (sdl.handle, sdl_syms[i]);
	  if (funcs[i] == NULL)
	    {
	      dlclose (sdl.handle);
	      sdl.handle = NULL;
	      return NULL;
	    }
	}
    }

  /* Create an SDL window if enabled and we don't have one yet.  */
  if (enabled && !state)
    {
      struct gui_state *gui = xmalloc (sizeof (*gui));
      if (!gui)
	return NULL;

      if (sdl.Init (SDL_INIT_VIDEO))
	goto error;

      gui->screen = sdl.SetVideoMode (width, height, bpp,
				      SDL_ANYFORMAT|SDL_HWSURFACE);
      if (!gui->screen)
	{
	  sdl.Quit();
	  goto error;
	}

      sdl.WM_SetCaption ("GDB Blackfin Simulator", NULL);
      sdl.ShowCursor (0);
      gui->bpp = bpp;
      gui->curr_line = 0;
      gui->throttle = 0;
      gui->throttle_limit = 0xf; /* XXX: let people control this ?  */
      return gui;

 error:
      free (gui);
      return NULL;
    }

  /* Else break down a window if disabled and we had one.  */
  else if (!enabled && state)
    {
      sdl.Quit();
      free (state);
      return NULL;
    }

  /* Retain existing state, whatever that may be.  */
  return state;
}

unsigned
bfin_gui_update (void *state, const void *source, unsigned nr_bytes)
{
  struct gui_state *gui = state;
  const Uint8 *src;
  Uint32 *pixels;
  unsigned i;

  if (!gui)
    return 0;

  /* XXX: Make this an option ?  */
  gui->throttle = (gui->throttle + 1) & gui->throttle_limit;
  if (gui->throttle)
    return 0;

  if (sdl.LockSurface(gui->screen))
    return 0;

  src = source;
  pixels = gui->screen->pixels;
  pixels += (gui->curr_line * gui->screen->w);
  switch (gui->bpp) /* XXX: Use gui->screen->format.  */
    {
    case 32: /* RGBA */
      memcpy(pixels, src, nr_bytes);
      break;

    case 24: /* RGB888 */
      for (i = 0; i < gui->screen->w; ++i)
	{
	  *pixels++ = sdl.MapRGB(gui->screen->format, src[0], src[1], src[2]);
	  src += 3;
	}
      break;

    case 16: /* RGB565 */
      /* XXX: todo ...  */
      break;
    }

  sdl.UnlockSurface(gui->screen);

  sdl.UpdateRect(gui->screen, 0, gui->curr_line, gui->screen->w, 1);
  gui->curr_line = ++gui->curr_line % gui->screen->h;

  return nr_bytes;
}

#endif
