
typedef unsigned long long u64;
struct super_block {
	unsigned s_blocksize;
	void *s_bdev;
};
sb_bread(struct super_block *sb, u64 block)
{
	__bread(sb->s_bdev, block, sb->s_blocksize);
}
fill(struct super_block *sb)
{
	u64 *bh;
	unsigned nr;
	nr = *bh >> 1;
	sb_bread(sb, nr);
}
