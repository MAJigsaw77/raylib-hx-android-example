package;

import ANSI;

class Tools
{
    public static function main():Void
    {
        final args:Array<String> = Sys.args();

        Sys.println(ANSI.apply(args.toString(), [Green, Bold]));
    }
}
