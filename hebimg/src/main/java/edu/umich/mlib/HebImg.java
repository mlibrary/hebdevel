package edu.umich.mlib;

import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.metadata.IIOMetadata;
import javax.imageio.metadata.IIOMetadataFormatImpl;
import javax.imageio.metadata.IIOMetadataNode;
import javax.imageio.stream.ImageInputStream;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.awt.image.ColorModel;
import java.io.*;
import java.time.LocalDateTime;
import java.util.*;
import java.util.List;

public class HebImg
{
    private enum FuncCode {
        CONVERT,
        META,
        RESIZE,
        RESIZE_OLD,
        TABLE
    }

    private static Map<String, FuncCode> STRING2FUNC = new HashMap<>();
    static {
        STRING2FUNC.put("convert", FuncCode.CONVERT);
        STRING2FUNC.put("meta", FuncCode.META);
        STRING2FUNC.put("resize", FuncCode.RESIZE);
        STRING2FUNC.put("resize_old", FuncCode.RESIZE_OLD);
        STRING2FUNC.put("table", FuncCode.TABLE);
    }

    public static void main( String[] args )
    {
        String funcName = args.length > 0 ? args[0] : "";
        FuncCode funcCode = STRING2FUNC.get(funcName);
        if (funcCode == null) {
            System.err.println("HebImg convert none|jpg|png|tif|jp2 imgFile [imgFile...]");
            System.err.println("HebImg resize pct outputDir imgFile [imgFile...]");
            System.err.println("HebImg table imgFile [imgFile...]");
            System.exit(1);
        }

        String[] params = Arrays.copyOfRange(args, 1, args.length);

        switch (funcCode) {
            case CONVERT:
                convert(params);
                break;
            case META:
                meta(params);
                break;
            case RESIZE:
                resize(params);
                break;
            case RESIZE_OLD:
                resizeOLD(params);
                break;
            case TABLE:
                table(params);
                break;
            default:
                System.err.println("Function \"" + funcName + "\" is not supported.");
                System.exit(1);
        }
    }

    private static void convert(String[] params)
    {
        if (params.length < 3) {
            System.err.println("HebImg convert outputFmt outputDir imgFile [imgFile...]");
            System.exit(1);
        }

        File outputDirFile = new File(params[1]);
        if (!outputDirFile.exists()) {
            System.err.println("Output directory \"" + params[0] + "\" does not exist.");
            System.exit(1);
        }

        String outputFmt = params[0];

        // Note the start time.
        System.out.println("\tStart time: " + LocalDateTime.now());

        for (int i = 2; i < params.length; i++) {
            String imgSrcPath = params[i];
            File imgSrcFile = new File(imgSrcPath);

            String pathName = imgSrcFile.getName();
            int ndx = pathName.lastIndexOf('.');
            String baseName = ndx == -1 ? pathName : pathName.substring(0, ndx);

            File imgDestFile = new File(outputDirFile, baseName + "." + outputFmt);

            System.out.println("Converting \"" + imgSrcFile.getName() + "\" to \"" + imgDestFile.getName() + "\".");
            if (!imgSrcFile.exists()) {
                System.err.println("\tSource file does not exist.");
                continue;
            }

            ImageIO.scanForPlugins();
            try {
                // Create the stream for the image.
                ImageInputStream is = ImageIO.createImageInputStream(imgSrcFile);

                // get the first matching reader
                Iterator<ImageReader> iterator = ImageIO.getImageReaders(is);
                boolean hasNext = iterator.hasNext();
                if (!hasNext) {
                    System.err.println("\tError: no reader for image \"" + imgSrcFile.getName() + "\".");
                    is.close();
                    continue;
                }

                ImageReader imageReader = iterator.next();
                imageReader.setInput(is);

                int pages = imageReader.getNumImages(true);
                if (pages > 1) {
                    // Image file contains multiple images. Not expected.
                    System.out.println("\tImage has " + pages + " pages. Using first.");
                }

                try {
                    BufferedImage bufferedImage = imageReader.read(0);
                    ImageIO.write(bufferedImage, outputFmt, imgDestFile);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                is.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Note the end time.
        System.out.println("\tEnd time: " + LocalDateTime.now());
    }

    private static void resize(String[] params)
    {
        if (params.length < 3) {
            System.err.println("HebImg resize pctList outputDir imgFile [imgFile...]");
            System.exit(1);
        }

        String resizePctList = params[0];
        String[] pctList = resizePctList.split(";");
        Map<Integer,Integer> pixel2pct = new HashMap<Integer,Integer>();
        for (String s : pctList) {
            String[] list = s.split(",");
            int pixelSize = Integer.parseInt(list[0]);
            int pct = Integer.parseInt(list[1]);
            pixel2pct.put(pixelSize, pct);
        }

        String outputDir = params[1];
        File outputDirFile = new File(outputDir);
        if (!outputDirFile.exists()) {
            System.err.println("Output directory \"" + outputDir + "\" does not exist.");
            System.exit(1);
        }

        // Note the start time.
        System.out.println("\tStart time: " + LocalDateTime.now());

        for (int i = 2; i < params.length; i++) {
            String imgSrcPath = params[i];
            File imgSrcFile = new File(imgSrcPath);

            String pathName = imgSrcFile.getName();
            int ndx = pathName.lastIndexOf('.');
            String baseName = ndx == -1 ? pathName : pathName.substring(0, ndx);

            File imgDestFile = new File(outputDirFile, baseName + ".png");
            String imgDestPath = imgDestFile.getAbsolutePath();

            System.out.println("Resizing \"" + imgSrcFile.getName() + "\" to \"" + imgDestPath + "\".");
            if (!imgSrcFile.exists()) {
                System.err.println("\tSource file does not exist.");
                continue;
            }


            try {
                BufferedImage inputImage = ImageIO.read(imgSrcFile);
                ColorModel model = inputImage.getColorModel();
                int pixelSize = model.getPixelSize();

                if (pixel2pct.containsKey(pixelSize)) {
                    int resizePct = pixel2pct.get(pixelSize);
                    System.out.println("\tPixel size is " + pixelSize + ". Reduce size by " + (100.0 - (resizePct)) + "%.");

                    int height = inputImage.getHeight() * resizePct / 100;
                    int width = inputImage.getWidth() * resizePct / 100;

                    BufferedImage resized = getScaledInstance(inputImage, width, height, RenderingHints.VALUE_INTERPOLATION_BICUBIC, true);
                    ImageIO.write(resized, "png", new File(imgDestPath));
                } else {
                    System.out.println("\tPixel size is " + pixelSize + ". Reduce size by 0%.");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Note the end time.
        System.out.println("\tEnd time: " + LocalDateTime.now());
    }

    private static void resizeOLD(String[] params)
    {
        if (params.length < 3) {
            System.err.println("HebImg resize pctList outputDir imgFile [imgFile...]");
            System.exit(1);
        }

        String resizePctList = params[0];
        String[] pctList = resizePctList.split(";");
        Map<Integer,Double> pixel2pct = new HashMap<Integer,Double>();
        for (String s : pctList) {
            String[] list = s.split(",");
            int pixelSize = Integer.parseInt(list[0]);
            double pct = Double.parseDouble(list[1]);
            pixel2pct.put(pixelSize, pct / 100.0);
        }

        String outputDir = params[1];
        File outputDirFile = new File(outputDir);
        if (!outputDirFile.exists()) {
            System.err.println("Output directory \"" + outputDir + "\" does not exist.");
            System.exit(1);
        }

        // Note the start time.
        System.out.println("\tStart time: " + LocalDateTime.now());

        for (int i = 2; i < params.length; i++) {
            String imgSrcPath = params[i];
            File imgSrcFile = new File(imgSrcPath);

            String pathName = imgSrcFile.getName();
            int ndx = pathName.lastIndexOf('.');
            String baseName = ndx == -1 ? pathName : pathName.substring(0, ndx);

            File imgDestFile = new File(outputDirFile, baseName + ".png");
            String imgDestPath = imgDestFile.getAbsolutePath();

            System.out.println("Resizing \"" + imgSrcFile.getName() + "\" to \"" + imgDestPath + "\".");
            if (!imgSrcFile.exists()) {
                System.err.println("\tSource file does not exist.");
                continue;
            }


            try {
                BufferedImage inputImage = ImageIO.read(imgSrcFile);
                ColorModel model = inputImage.getColorModel();
                int pixelSize = model.getPixelSize();

                if (pixel2pct.containsKey(pixelSize)) {
                    double resizePct = pixel2pct.get(pixelSize);
                    System.out.println("\tPixel size is " + pixelSize + ". Reduce size by " + (100.0 - (resizePct * 100)) + "%.");
                    ImageResizer.resize(inputImage, imgDestPath, resizePct);
                } else {
                    System.out.println("\tPixel size is " + pixelSize + ". Reduce size by 0%.");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Note the end time.
        System.out.println("\tEnd time: " + LocalDateTime.now());
    }

    private static void table(String[] params)
    {
        if (params.length < 1) {
            System.err.println("HebImg table imgFile [imgFile...]");
            System.exit(1);
        }

        // Query the HEB scanned images.
        ImageIO.scanForPlugins();

        List<ImgFileInfo> infoList = new ArrayList<ImgFileInfo>();

        try {
            for (String imgSrcPath : params) {
                File imgSrcFile = new File(imgSrcPath);
                if (!imgSrcFile.exists()) {
                    //System.err.println("\tSource file does not exist.");
                    continue;
                }

                String source = imgSrcFile.getName();

                // Create the stream for the image.
                ImageInputStream is = ImageIO.createImageInputStream(imgSrcFile);

                // get the first matching reader
                Iterator<ImageReader> iterator = ImageIO.getImageReaders(is);
                boolean hasNext = iterator.hasNext();
                if (!hasNext) {
                    // Not expected.
                    is.close();
                    continue;
                }

                ImageReader imageReader = iterator.next();
                imageReader.setInput(is);

                //int pages = imageReader.getNumImages(true);
                //if (pages > 1) {
                // Image file contains multiple images. Not expected.
                //System.out.println("\tImage has " + pages + " pages. Using first.");
                //}

                ImgFileInfo info = new ImgFileInfo(source, true, imageReader);
                is.close();

                infoList.add(info);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Calculate mean, mode, min, max width/height for the list of images.
        ImgListInfo listInfo = new ImgListInfo();
        for (ImgFileInfo info : infoList) {
            listInfo.add(info);
        }

        // Output the results.
        int avgWidth = infoList.size() > 0 ? listInfo.getTotalWidth() / infoList.size() : 0;
        int avgHeight = infoList.size() > 0 ? listInfo.getTotalHeight() / infoList.size() : 0;

        BufferedWriter writer = null;
        try {
            writer = new BufferedWriter(new OutputStreamWriter(System.out));
            writer.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            writer.newLine();
            writer.write("<table xmlns=\"http://www.w3.org/1999/xhtml\" " +
                    "xmlns:mlib=\"http://www.mlib.umich.edu/namespace/mlib\" " +
                    "mlib:avgwidth=\"" + avgWidth + "\" " +
                    "mlib:minwidth=\"" + listInfo.getMinWidth() + "\" " +
                    "mlib:maxwidth=\"" + listInfo.getMaxWidth() + "\" " +
                    "mlib:avgheight=\"" + avgHeight + "\" " +
                    "mlib:minheight=\"" + listInfo.getMinHeight() + "\" " +
                    "mlib:maxheight=\"" + listInfo.getMaxHeight() + "\" " +
                    "id=\"images\" title=\"Images\">");
            writer.newLine();
            writer.write("<caption>Images</caption>");
            writer.newLine();
            writer.write("<thead>");
            writer.newLine();
            writer.write("<tr>");
            writer.newLine();
            writer.write("<th class=\"source\">source</th>");
            writer.newLine();
            writer.write("<th class=\"exists\">exists</th>");
            writer.newLine();
            writer.write("<th class=\"format\">format</th>");
            writer.newLine();
            writer.write("<th class=\"width\">width</th>");
            writer.newLine();
            writer.write("<th class=\"height\">height</th>");
            writer.newLine();
            writer.write("<th class=\"colortype\">Color Type</th>");
            writer.newLine();
            writer.write("<th class=\"channels\">Number of Channels</th>");
            writer.newLine();
            writer.write("<th class=\"bitspersample\">Bits/Sample</th>");
            writer.newLine();
            writer.write("</tr>");
            writer.newLine();
            writer.write("</thead>");
            writer.newLine();
            writer.write("<tbody>");
            writer.newLine();

            for (ImgFileInfo info : infoList) {

                String source = info.getFileName();
                boolean exists = info.exists();
                String format = info.getFormatName();
                int width = info.getWidth();
                int height = info.getHeight();
                String colorSpaceType = info.getColorSpaceType();
                String numChannels = info.getNumChannels();
                String bitsPerSample = info.getBitsPerSample();

                writer.write("<tr>");
                writer.newLine();

                writer.write("<td class=\"source\">" + source + "</td>");
                writer.newLine();
                writer.write("<td class=\"exists\">true</td>");
                writer.newLine();

                // Determine the image format
                writer.write("<td class=\"format\">"+ format + "</td>");
                writer.newLine();

                writer.write("<td class=\"width\">"+ width + "</td>");
                writer.newLine();
                writer.write("<td class=\"height\">"+ height + "</td>");
                writer.newLine();
                writer.write("<td class=\"colortype\">"+ colorSpaceType + "</td>");
                writer.newLine();
                writer.write("<td class=\"channels\">"+ numChannels + "</td>");
                writer.newLine();
                writer.write("<td class=\"bitspersample\">"+ bitsPerSample + "</td>");
                writer.newLine();
                writer.write("</tr>");
                writer.newLine();
                writer.flush();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (writer != null) {
                    writer.write("</tbody>");
                    writer.newLine();
                    writer.write("</table>");
                    writer.newLine();
                    writer.flush();
                    //writer.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private static class ImgFileInfo
    {
        private final String m_fileName;
        private final boolean m_exists;
        private final String m_formatName;
        private final int m_width;
        private final int m_height;
        private final String m_colorSpaceType;
        private final String m_numChannels;
        private final String m_bitsPerSample;

        ImgFileInfo(String fileName, boolean exists, String formatName, int width, int height,
                    String colorSpaceType, String numChannels, String bitsPerSample)
        {
            m_fileName = fileName;
            m_exists = exists;
            m_formatName = formatName;
            m_width = width;
            m_height = height;
            m_colorSpaceType = colorSpaceType;
            m_numChannels = numChannels;
            m_bitsPerSample = bitsPerSample;
        }

        ImgFileInfo(String fileName, boolean exists, ImageReader imageReader)
        {
            String formatName = null;
            int width = 0;
            int height = 0;
            String colorSpaceType = "";
            String numChannels = "";
            String bitsPerSample = "";

            try {

                // Determine the image format
                formatName = imageReader.getFormatName();

                // Determine the width and height of the image.
                // These are collected into a formatted string and passed
                // to the XSLT. They are used to to set the viewport in the
                // image xhtml file. These are needed for the epub.js reader.
                // They can be used for readium, but it appears that they are
                // not required. width=device_width,height=device_height works.
                width = imageReader.getWidth(0);
                height = imageReader.getHeight(0);

                // Query metadata document for colorSpaceType, numChannels and bitsPerSample.
                IIOMetadata metadata = imageReader.getImageMetadata(0);
                if (metadata != null && metadata.isStandardMetadataFormatSupported()) {

                    IIOMetadataNode standardTree = (IIOMetadataNode)
                            metadata.getAsTree(IIOMetadataFormatImpl.standardMetadataFormatName);

                    NodeList nodeList = standardTree.getElementsByTagName("ColorSpaceType");
                    Element elem = nodeList != null && nodeList.getLength() > 0 ? (Element) nodeList.item(0) : null;
                    if (elem != null) {
                        colorSpaceType = elem.getAttribute("name");
                    }

                    nodeList = standardTree.getElementsByTagName("NumChannels");
                    elem = nodeList != null && nodeList.getLength() > 0 ? (Element) nodeList.item(0) : null;
                    if (elem != null) {
                        numChannels = elem.getAttribute("value");
                    }

                    nodeList = standardTree.getElementsByTagName("BitsPerSample");
                    elem = nodeList != null && nodeList.getLength() > 0 ? (Element) nodeList.item(0) : null;
                    if (elem != null) {
                        bitsPerSample = elem.getAttribute("value");
                    }
                }

            } catch (Exception e) {
                e.printStackTrace();
            }

            m_fileName = fileName;
            m_exists = exists;
            m_formatName = formatName;
            m_width = width;
            m_height = height;
            m_colorSpaceType = colorSpaceType;
            m_numChannels = numChannels;
            m_bitsPerSample = bitsPerSample;
        }

        public String getFileName() {
            return m_fileName;
        }

        public boolean exists() {
            return m_exists;
        }

        public String getFormatName() {
            return m_formatName;
        }

        public int getWidth() {
            return m_width;
        }

        public int getHeight() {
            return m_height;
        }

        public String getColorSpaceType() {
            return m_colorSpaceType;
        }

        public String getNumChannels() {
            return m_numChannels;
        }

        public String getBitsPerSample() {
            return m_bitsPerSample;
        }
    }

    private static class ImgListInfo
    {
        private int m_totalWidth;
        private int m_minWidth;
        private int m_maxWidth;
        private int m_totalHeight;
        private int m_minHeight;
        private int m_maxHeight;
        private Map<Integer, Integer> m_widthMap;

        ImgListInfo()
        {
            m_totalWidth = 0;
            m_minWidth = 1000000;
            m_maxWidth = 0;
            m_totalHeight = 0;
            m_minHeight = 1000000;
            m_maxHeight = 0;

            m_widthMap = new HashMap<Integer, Integer>();
        }

        public void add(ImgFileInfo info)
        {
            int width = info.getWidth();
            int height = info.getHeight();

            m_totalWidth += width;
            m_totalHeight += height;

            m_minWidth = Integer.min(m_minWidth, width);
            m_maxWidth = Integer.max(m_maxWidth, width);
            m_minHeight = Integer.min(m_minHeight, height);
            m_maxHeight = Integer.max(m_maxHeight, height);

            int widthCnt = m_widthMap.containsKey(width) ? m_widthMap.get(width) : 0;
            m_widthMap.put(width, widthCnt+1);
        }

        public int getTotalWidth() {
            return m_totalWidth;
        }

        public int getMinWidth() {
            return m_minWidth;
        }

        public int getMaxWidth() {
            return m_maxWidth;
        }

        public int getTotalHeight() {
            return m_totalHeight;
        }

        public int getMinHeight() {
            return m_minHeight;
        }

        public int getMaxHeight() {
            return m_maxHeight;
        }
    }

    private static void meta(String[] params)
    {
        if (params.length < 1) {
            System.err.println("HebImg meta imgFile [imgFile...]");
            System.exit(1);
        }

        ImageIO.scanForPlugins();
        try {

            for (String imgSrcPath : params) {
                File imgSrcFile = new File(imgSrcPath);

                System.out.println("Reading \"" + imgSrcFile.getName() + "\".");
                if (!imgSrcFile.exists()) {
                    System.err.println("\tSource file does not exist.");
                    continue;
                }

                String source = imgSrcFile.getName();

                // Create the stream for the image.
                ImageInputStream is = ImageIO.createImageInputStream(imgSrcFile);

                // get the first matching reader
                Iterator<ImageReader> iterator = ImageIO.getImageReaders(is);
                boolean hasNext = iterator.hasNext();
                if (!hasNext) {
                    System.err.println("\tError: no reader for image \"" + source + "\".");

                    is.close();
                    continue;
                }

                ImageReader imageReader = iterator.next();

                imageReader.setInput(is);

                int pages = imageReader.getNumImages(true);
                if (pages > 1) {
                    // Image file contains multiple images. Not expected.
                    System.out.println("\tImage has " + pages + " pages. Using first.");
                }

                // Query metadata document
                IIOMetadata metadata = imageReader.getImageMetadata(0);
                if (metadata != null && metadata.isStandardMetadataFormatSupported()) {

                    IIOMetadataNode standardTree = (IIOMetadataNode)
                            metadata.getAsTree(IIOMetadataFormatImpl.standardMetadataFormatName);
                    dumpNode(standardTree);

                    standardTree = (IIOMetadataNode)
                            metadata.getAsTree(metadata.getNativeMetadataFormatName());
                    dumpNode(standardTree);

                }

                is.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private static void dumpNode(Node node)
    {
        String nme = node.getLocalName();
        short t = node.getNodeType();
        NodeList cl1 = node.getChildNodes();
        System.out.println("nme=" +nme+",type="+t+",children=" + cl1.getLength());

        NamedNodeMap map = node.getAttributes();
        for (int i = 0; i < map.getLength(); i++) {
            Node a = map.item(i);
            String anme = a.getNodeName();
            String v = a.getNodeValue();
            System.out.println("attr=" +anme+",val="+v);
        }
        for (int i = 0; i < cl1.getLength(); i++) {
            Node n = cl1.item(i);
            dumpNode(n);
        }

    }

    public static BufferedImage getScaledInstance(BufferedImage img,
                                           int targetWidth,
                                           int targetHeight,
                                           Object hint,
                                           boolean higherQuality)
    {
        //int type = (img.getTransparency() == Transparency.OPAQUE) ?
        //        BufferedImage.TYPE_INT_RGB : BufferedImage.TYPE_INT_ARGB;
        //int type = BufferedImage.TYPE_BYTE_BINARY;
        int type = img.getType();
        type = type == 0 ? BufferedImage.TYPE_4BYTE_ABGR_PRE : type;

        BufferedImage ret = (BufferedImage)img;
        int w, h;
        if (higherQuality) {
            // Use multi-step technique: start with original size, then
            // scale down in multiple passes with drawImage()
            // until the target size is reached
            w = img.getWidth();
            h = img.getHeight();
        } else {
            // Use one-step technique: scale directly from original
            // size to target size with a single drawImage() call
            w = targetWidth;
            h = targetHeight;
        }

        do {
            if (higherQuality && w > targetWidth) {
                w /= 2;
                if (w < targetWidth) {
                    w = targetWidth;
                }
            }

            if (higherQuality && h > targetHeight) {
                h /= 2;
                if (h < targetHeight) {
                    h = targetHeight;
                }
            }

            BufferedImage tmp = new BufferedImage(w, h, type);
            Graphics2D g2 = tmp.createGraphics();
            g2.setRenderingHint(RenderingHints.KEY_INTERPOLATION, hint);
            g2.drawImage(ret, 0, 0, w, h, null);
            g2.dispose();

            ret = tmp;
        } while (w != targetWidth || h != targetHeight);

        return ret;
    }
    private static BufferedImage progressiveScaling(BufferedImage before, Integer longestSideLength) {
        if (before != null) {
            Integer w = before.getWidth();
            Integer h = before.getHeight();

            Double ratio = h > w ? longestSideLength.doubleValue() / h : longestSideLength.doubleValue() / w;

            //Multi Step Rescale operation
            //This technique is describen in Chris Campbell’s blog The Perils of Image.getScaledInstance(). As Chris mentions, when downscaling to something less than factor 0.5, you get the best result by doing multiple downscaling with a minimum factor of 0.5 (in other words: each scaling operation should scale to maximum half the size).
            while (ratio < 0.5) {
                BufferedImage tmp = scale(before, 0.5);
                before = tmp;
                w = before.getWidth();
                h = before.getHeight();
                ratio = h > w ? longestSideLength.doubleValue() / h : longestSideLength.doubleValue() / w;
            }
            BufferedImage after = scale(before, ratio);
            return after;
        }
        return null;
    }

    private static BufferedImage scale(BufferedImage imageToScale, Double ratio) {
        Integer dWidth = ((Double) (imageToScale.getWidth() * ratio)).intValue();
        Integer dHeight = ((Double) (imageToScale.getHeight() * ratio)).intValue();
        BufferedImage scaledImage = new BufferedImage(dWidth, dHeight, BufferedImage.TYPE_INT_RGB);
        Graphics2D graphics2D = scaledImage.createGraphics();
        graphics2D.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
        graphics2D.drawImage(imageToScale, 0, 0, dWidth, dHeight, null);
        graphics2D.dispose();
        return scaledImage;
    }
}
