/*******************************************************************************
 *  Copyright (c) 2012 Analog Devices, Inc.
 *  All rights reserved. This program and the accompanying materials
 *  are made available under the terms of the Eclipse Public License v1.0
 *  which accompanies this distribution, and is available at
 *  http://www.eclipse.org/legal/epl-v10.html
 *
 *  Contributors:
 *     Analog Devices, Inc. - Initial implementation
 *******************************************************************************/
package com.analog.gnu.toolchain.blackfin.build;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.eclipse.cdt.utils.Platform;
import org.eclipse.core.runtime.FileLocator;
import org.eclipse.core.runtime.Path;
import org.osgi.framework.Bundle;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.analog.gnu.toolchain.blackfin.Activator;
import com.analog.gnu.toolchain.blackfin.Utility;

/**
 * ProcessorInfo is used for accessing the processor information stored in the
 * GnuToolchainProcessorInfo.xml file.
 */
public class ProcessorInfo {

	/** Singleton instance of this class. */
	static private ProcessorInfo processorInfo;

	/** Object representing GnuToochainProcessorInfo.xml. We reference this
	 * quite a bit so we're better off caching it rather than 
	 * reparsing the file for every call.
	 */
	private Document xmlDoc;

	/** The XPath expression evaluator to use in parsing the XML */
	private XPath xpathEvaluator = XPathFactory.newInstance().newXPath();

	/** The IDDE xml filename to parse */
	static final private String XML_FILENAME = "GnuToolchainProcessorInfo.xml";

	/** The processor number of cores attribute used in getProcessorNumberOfCores() */
	static final public String NUMBER_OF_CORES = "numberOfCores";

	/**
	 * This is the constructor that parses the ADSP-IDDE.xml file.
	 */
	public ProcessorInfo() {

		// parse the xml file
		DocumentBuilderFactory domFactory = DocumentBuilderFactory.newInstance();
		domFactory.setNamespaceAware(true);
		xmlDoc = parseXml(XML_FILENAME);
	}

	/**
	 * Get the only instance of this class.
	 * 
	 * @return the only instance of this class.
	 */
	public static ProcessorInfo getInstance() {
		if (null == processorInfo) {
			processorInfo = new ProcessorInfo();
		}
		return processorInfo;
	}

	/**
	 * @return the list of all processors supported by this installation of
	 *         VisualDP++
	 */
	public final ArrayList<String> getAllProcessors() {
		return getValuesForExpression("//processor/@name", xmlDoc);
	}

	/**
	 * @param processor the processor name
	 * @return the number of cores for that processor
	 */
	public final int getProcessorNumberOfCores(String processor) {
		try	{
			return Integer.parseInt(getValueForExpression(
					"//processor[@name='" + processor + "']/@" + NUMBER_OF_CORES, xmlDoc));
		}
		catch(NumberFormatException nfe)	{
			Utility.logError(Activator.getDefault(), "Error getting number of cores for " + processor, nfe);
			return -1;
		}
	}

	/**
	 * A private helper method that returns the resulting string value for the
	 * specified XPath expression.
	 * 
	 * @param expression the XPath query to execute
	 * @param xmlDoc the XML document to query
	 * @return The value of the query
	 */
	private String getValueForExpression(String expression, Document xmlDoc) {

		String value = "";

		try {
			value = (String) xpathEvaluator.evaluate(expression, xmlDoc, XPathConstants.STRING);

		}
		catch (XPathExpressionException exception) {
			Utility.logError(Activator.getDefault(),
				"Failed to load attribute from product configuration file with expression: "
					+ expression, exception);
		}

		return value;
	}

	/**
	 * A helper method that parses an XML file and returns the Document object representing
	 * its DOM.
	 * @param fileName name of the file (assumed to be in the $(VDSP)/System/ArchDef directory
	 * @return the XML document if successful or null otherwise
	 */
	private Document parseXml(String fileName) {

		Document xmlDoc = null;
		DocumentBuilderFactory domFactory = DocumentBuilderFactory.newInstance();
		domFactory.setNamespaceAware(true);
		
		try {
			DocumentBuilder builder = domFactory.newDocumentBuilder();
			try {
				Bundle bundle = Platform.getBundle(Activator.PLUGIN_ID);
				Path path = new Path("GnuToolchainProcessorInfo.xml");
				URL url = FileLocator.find(bundle, path, null);
				String filePath = FileLocator.toFileURL(url).getPath();
				xmlDoc = builder.parse(new File(filePath));
			}
			catch (SAXException exception) {
				Utility.logError(Activator.getDefault(),
					"Failed to parse product configuration file.", exception);
			}
			catch (IOException exception) {
				Utility.logError(Activator.getDefault(),
					"Failed to open product configuration file.", exception);
			}
		}
		catch (ParserConfigurationException exception) {
			Utility.logError(Activator.getDefault(),
				"Failed to parse product configuration file.", exception);
		}
		
		return xmlDoc;
	}

	/**
	 * A private helper method that returns an array of all String values for
	 * the XML nodes returned by the specified XPath expression in the specified
	 * document.
	 * 
	 * @param expression the XPath query to execute
	 * @param xmlDoc the XML document to query
	 * @return The list of all values returned by the query
	 */
	private ArrayList<String> getValuesForExpression(String expression, Document xmlDoc) {
		ArrayList<String> values = new ArrayList<String>();

		try {
			NodeList nodes = (NodeList) xpathEvaluator.evaluate(expression, xmlDoc,
				XPathConstants.NODESET);

			if (null != nodes) {
				for (int i = 0; i < nodes.getLength(); i++) {
					values.add(nodes.item(i).getNodeValue());
				}
			}
		}
		catch (XPathExpressionException exception) {
			Utility.logError(Activator.getDefault(),
				"Failed to load attributes from product configuration file with expression: "
					+ expression, exception);
		}

		return values;
	}
}
