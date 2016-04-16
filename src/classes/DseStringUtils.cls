/**
* This was provided by a opensource group.
* String manipulation mnost common functions. 
*/
public class DseStringUtils {

    public static String getSObjectField(String str) { 
        if (str == null) { 
            return ''; 
        } 

        return str; 
    }

    public static Boolean isNotNullOrEmpty(String str) { 
        return !isNullOrEmpty(str); 
    }
    public static Boolean isNullOrEmpty(String str) {
        // If the string is null  
        if (str == null) { 
            return true; 
        }

        // If the string contains only spaces
        String tmp = null; 
        tmp = str.replaceAll(' ', ''); 

        if (tmp.length() == 0) { 
            return true; 
        }

        return false; 
    }

    public static Boolean equalsIgnoreCase(String str1, String str2) { 
        // both strings must contain something
        if (str1 == null || str2 == null) { 
            return false;
        }

        // Use default functionality 
        return str1.equalsIgnoreCase(str2); 
    }

    public static Boolean notEqualsIgnoreCase(String str1, String str2) { 
        return !equalsIgnoreCase(str1, str2); 
    }

    public static Boolean contains(String str, String searchStr) {
        // ensure the main string is not null 
        if (str == null) { 
            return false; 
        }

        // we actually have something to search for
        if (searchStr == null) { 
            return false;
        }

        // Search for it
        return str.contains(searchStr);          
    }

    public static Boolean containsIgnoreCase(String str, String searchStr) { 
        // ensure the main string is not null 
        if (str == null) { 
            return false; 
        }

        // we actually have something to search for
        if (searchStr == null) { 
            return false;
        }

        // Lowercase the str and searchStr and check it 
        return str.toLowerCase().contains(searchStr.toLowerCase()); 
    }
}