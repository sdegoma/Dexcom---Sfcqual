public class UtilityClass {
    public static Boolean runTrigger = true;
    public static Boolean runOnce(){
        if(runTrigger == true){
            runTrigger = false;
            return true;
        }else{
            return runTrigger;
        }
    }
}