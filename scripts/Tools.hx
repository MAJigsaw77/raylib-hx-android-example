package;

import ANSI;

@:nullSafety
class Tools
{
    public static function main():Void
    {
        final args:Array<String> = Sys.args();
        final command:Null<String> = args.shift();
        final runDir:Null<String> = args.pop();

        if (command != null)
            Sys.println(ANSI.apply(command, [Red, Bold]));

        if (runDir != null)
            Sys.println(ANSI.apply(runDir, [Blue, Underline]));

        Sys.println(ANSI.apply(args.toString(), [Green, Underline]));
    }
}
