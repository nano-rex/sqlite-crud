import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Scanner;

public class InvoiceGenerator {
    private static String filepath1 = "";

    public static void main(String[] args) {
        openGui();
    }

    private static String addPrefixToLastWord(String text, String prefix) {
        String[] words = text.split("/");
        String lastWord = words[words.length - 1];
        String newLastWord = prefix + lastWord;
        words[words.length - 1] = newLastWord;
        String modifiedText = String.join("/", words);
        return modifiedText;
    }

    private static void openFolder() {
        Scanner scanner = new Scanner(System.in);
        System.out.println("Please enter the file path:");
        filepath1 = scanner.nextLine();
    }

    private static void gch() {
        String filepath2 = addPrefixToLastWord(filepath1, "INV_");
        try {
            Files.copy(new File("/home/user/Templates/INV_GCH.xlsx").toPath(), new File(filepath2).toPath(), StandardCopyOption.REPLACE_EXISTING);
            // Perform the necessary operations on the Excel file
            // ...
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void d_o() {
        String filepath2 = addPrefixToLastWord(filepath1, "INV_");
        try {
            Files.copy(new File("/home/user/Templates/INV_.xlsx").toPath(), new File(filepath2).toPath(), StandardCopyOption.REPLACE_EXISTING);
            // Perform the necessary operations on the Excel file
            // ...
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void dm() {
        String filepath2 = addPrefixToLastWord(filepath1, "INV_");
        try {
            Files.copy(new File("/home/user/Templates/INV_.xlsx").toPath(), new File(filepath2).toPath(), StandardCopyOption.REPLACE_EXISTING);
            // Perform the necessary operations on the Excel file
            // ...
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void openGui() {
        openFolder();
        Scanner scanner = new Scanner(System.in);
        System.out.println("Please select an option:");
        System.out.println("1. GCH");
        System.out.println("2. D.O");
        System.out.println("3. DM");
        int option = scanner.nextInt();
        switch (option) {
            case 1:
                gch();
                break;
            case 2:
                d_o();
                break;
            case 3:
                dm();
                break;
            default:
                System.out.println("Invalid option");
                break;
        }
    }
}
