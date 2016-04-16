/* this is used to prevent a trigger is called recursively */
public Class DseCheckRecursive
{
    private static boolean run = true;
    public static boolean runOnce() 
    {
        if (run)
        {
            run = false;
            return true;
        }
        else
        {
            return run;
        }
    }
    public static void reset()
    {
        run = true;
    }
}