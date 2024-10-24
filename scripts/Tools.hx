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
        {
            Sys.println(ANSI.apply('Running command ', [Red]) + ANSI.apply(command, [Underline, Red]) + ANSI.apply('...', [Red]));

            switch (command)
            {
                // case 'build':
                default:
                    Sys.println(ANSI.apply('Unknown command ', [Red]) + ANSI.apply(command, [Underline, Red]) + ANSI.apply('...', [Red]));
                    Sys.exit(1);
            }
        }

        if (runDir != null)
            Sys.println(ANSI.apply(runDir, [Blue, Underline]));

        Sys.println(ANSI.apply(args.toString(), [Green, Underline]));
    }
}
