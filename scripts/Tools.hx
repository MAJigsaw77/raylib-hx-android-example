package;

import ANSI;

@:nullSafety
class Tools
{
    public static function main():Void
    {
        final args:Array<String> = Sys.args();
        final command:String = args.shift();
        final runDir:String= args.pop();

        Sys.println(ANSI.apply(command, [Red, Bold]));
        Sys.println(ANSI.apply(runDir, [Blue, Underline]));
        Sys.println(ANSI.apply(args.toString(), [Green, Underline]));
    }
}
