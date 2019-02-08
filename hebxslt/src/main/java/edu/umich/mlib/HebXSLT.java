package edu.umich.mlib;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;

public class HebXSLT
{

    public static void main( String[] args )
    {
        if (args.length < 2) {
            System.err.println("Syntax: HebXSLT xsltPath hebXmlFile [hebXmlFile...]");
            System.exit(1);
        }

        // Determine the XSLT file to use.
        String xsltPath = args[0];
        File xsltFile = new File(xsltPath);
        if (!xsltFile.exists()) {
            System.err.println("XSLT path \"" + xsltPath + "\" does not exist.");
            System.exit(2);
        }

        Source xslSource = new StreamSource(xsltFile);

        // Create the XSLT transformer.
        Transformer transformer = null;
        try {
            transformer = TransformerFactory.newInstance().newTransformer(xslSource);
        } catch (TransformerException e) {
            e.printStackTrace();
            System.exit(3);
        }

        // Need to specify a output file, the XSLT stylesheet doesn't
        // populate it.
        File resultFile = new File("result.xml");
        Result result = new StreamResult(resultFile.getAbsoluteFile().toURI().getPath());

        // Process each of the HEB directories specified on the command line
        for (int i = 1; i < args.length; i++) {
            System.out.println("\tProcessing \"" + args[i] + "\"");

            File hebXmlFile = new File(args[i]);
            if (!hebXmlFile.exists()) {
                System.err.println("\t\tHEB XML file \"" + hebXmlFile.getPath() + "\" does not exist.");
                continue;
            }

            // Get the directory
            File hebDirFile = hebXmlFile.getParentFile();

            // Prepare the parameters for the XSLT transformation.
            transformer.setParameter("working-dir", hebDirFile.getAbsoluteFile().toURI().toString());

            // Use the full XML file as input to transformation. There is
            // no default output file as the transformation creates multiple
            // files.
            Source inputXml = new StreamSource(hebXmlFile);

            try {
                transformer.transform(inputXml, result);
            } catch (TransformerException e) {
                e.printStackTrace();
            }

            System.out.println("\tCompleted.");

            transformer.reset();
        }
    }
}
