package;

import haxe.io.Path;
import sys.FileSystem;
import ANSI;

@:nullSafety
class Tools
{
	private static var NDK_DIR:Null<String> = null;

	public static function main():Void
	{
		final args:Array<String> = Sys.args();
		final command:Null<String> = args.shift();
		final runDir:Null<String> = args.pop();

		if (command != null)
		{
			switch (command)
			{
				case 'build':
					setupNDK();

					Sys.exit(0);
				default:
					Sys.println(ANSI.apply('Unknown command ', [Red]) + ANSI.apply(command, [Italic, Red]) + ANSI.apply('...', [Red]));
					Sys.exit(1);
			}
		}

		if (runDir != null)
			Sys.println(ANSI.apply(runDir, [Blue, Underline]));

		Sys.println(ANSI.apply(args.toString(), [Green, Underline]));
	}

	private static function setupNDK():Void
	{
		NDK_DIR = Sys.getEnv('ANDROID_NDK_ROOT');

		if (NDK_DIR == null)
		{
			Sys.println(ANSI.apply('ANDROID_NDK_ROOT is not set, searching for NDK...', [Yellow]));

			switch (Sys.systemName())
			{
				case sys if (new EReg("window", "i").match(sys)):
					Sys.println(ANSI.apply('Please set ANDROID_NDK_ROOT manually.', [Red]));
					Sys.exit(1);
				case sys if (new EReg("mac", "i").match(sys)):
					NDK_DIR = Path.join([Sys.getEnv('HOME'), '/Library/Android/sdk/ndk']);
				case sys if (new EReg("linux", "i").match(sys)):
					if (FileSystem.exists(Path.join([Sys.getEnv('HOME'), '/Android/Sdk/ndk'])))
						NDK_DIR = Path.join([Sys.getEnv('HOME'), '/Android/Sdk/ndk']);
					else if (FileSystem.exists('/usr/local/android-ndk'))
						NDK_DIR = '/usr/local/android-ndk';
					else
					{
						Sys.println(ANSI.apply('Could not find the Android NDK automatically. Please set ANDROID_NDK_ROOT.', [Red]));
						Sys.exit(1);
					}
				default:
					Sys.println(ANSI.apply('Unsupported OS. Please set ANDROID_NDK_ROOT manually.', [Red]));
					Sys.exit(1);
			}
		}

		if (NDK_DIR != null)
			Sys.println(ANSI.apply('Using Android NDK at $NDK_DIR', [Green]));
	}
}
