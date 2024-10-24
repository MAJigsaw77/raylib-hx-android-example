package;

import haxe.io.Path;
import sys.FileSystem;

@:nullSafety
class Runner
{
	private static var NDK_DIR:Null<String> = null;

	public static function main():Void
	{
		final args:Array<String> = Sys.args();
		final runDir:Null<String> = args.pop();
		final command:Null<String> = args.shift();

		if (command != null)
		{
			switch (command)
			{
				case 'build':
					setupNDK();
				default:
					Sys.println(ANSI.apply('Unknown command ', [Red]) + ANSI.apply(command, [Italic, Red]) + ANSI.apply('...', [Red]));
					Sys.exit(1);
			}
		}

		Sys.exit(0);
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

enum abstract ANSICode(String) from String to String
{
	var Black = '\033[0;30m';
	var Red = '\033[0;31m';
	var Green = '\033[0;32m';
	var Yellow = '\033[0;33m';
	var Blue = '\033[0;34m';
	var Magenta = '\033[0;35m';
	var Cyan = '\033[0;36m';
	var Gray = '\033[0;37m';
	var White = '\033[1;37m';

	var BgBlack = '\033[40m';
	var BgRed = '\033[41m';
	var BgGreen = '\033[42m';
	var BgYellow = '\033[43m';
	var BgBlue = '\033[44m';
	var BgMagenta = '\033[45m';
	var BgCyan = '\033[46m';
	var BgWhite = '\033[47m';

	var Reset = '\033[0m';
	var Bold = '\033[1m';
	var Italic = '\033[3m';
	var Underline = '\033[4m';
	var Strikethrough = '\033[9m';
	var DoubleUnderline = '\033[21m';
	var Blink = '\033[5m';
	var Inverse = '\033[7m';
	var Hidden = '\033[8m';

	var BoldOff = '\033[22m';
	var ItalicOff = '\033[23m';
	var UnderlineOff = '\033[24m';
	var BlinkOff = '\033[25m';
	var InverseOff = '\033[27m';
	var HiddenOff = '\033[28m';
}

/**
 * Utility class for applying ANSI codes to strings for terminal output.
 */
class ANSI
{
	/**
	 * Common CI environment variable names used to detect ANSI code support.
	 */
	@:noCompletion
	private static final CI_ENV_NAMES:Array<String> = [
		'GITHUB_ACTIONS',
		'GITEA_ACTIONS',
		'TRAVIS',
		'CIRCLECI',
		'APPVEYOR',
		'GITLAB_CI',
		'BUILDKITE',
		'DRONE'
	];

	/**
	 * Indicates if ANSI code support is available in the terminal.
	 */
	@:noCompletion
	private static var codesSupported:Null<Bool> = null;

	/**
	 * Applies the specified ANSI codes to the input string.
	 * You can pass one or multiple ANSI codes for combining styles.
	 * @param input The input string.
	 * @param codes The ANSI codes to apply.
	 * @return The styled string.
	 */
	public static function apply(input:String, codes:Array<ANSICode>, reset:Bool = true):String
	{
		return stripCodes(codes.join('') + input + ANSICode.Reset);
	}

	/**
	 * Strips ANSI codes from the input string if the terminal doesn't support them.
	 * @param output The string to check for ANSI code support.
	 * @return The string with or without ANSI codes depending on terminal support.
	 */
	@:noCompletion
	private static function stripCodes(output:String):String
	{
		if (codesSupported == null)
		{
			final term:String = Sys.getEnv('TERM');

			if (term == 'dumb')
				codesSupported = false;
			else
			{
				if (Sys.getEnv('CI') != null)
				{
					for (ci in CI_ENV_NAMES)
					{
						if (Sys.getEnv(ci) != null)
						{
							codesSupported = true;
							break;
						}
					}

					if (codesSupported != true && Sys.getEnv('CI_NAME') == 'codeship')
						codesSupported = true;
				}

				if (codesSupported != true && Sys.getEnv('TEAMCITY_VERSION') != null)
					codesSupported = ~/^9\.(0*[1-9]\d*)\.|\d{2,}\./.match(Sys.getEnv('TEAMCITY_VERSION'));

				if (codesSupported != true && term != null)
				{
					codesSupported = ~/(?i)-256(color)?$/.match(term)
						|| ~/(?i)^screen|^xterm|^vt100|^vt220|^rxvt|color|ansi|cygwin|linux/.match(term);
				}

				if (codesSupported != true)
				{
					codesSupported = Sys.getEnv('TERM_PROGRAM') == 'iTerm.app'
						|| Sys.getEnv('TERM_PROGRAM') == 'Apple_Terminal'
						|| Sys.getEnv('COLORTERM') != null
						|| Sys.getEnv('ANSICON') != null
						|| Sys.getEnv('ConEmuANSI') != null
						|| Sys.getEnv('WT_SESSION') != null;
				}
			}
		}

		return codesSupported == true ? output : ~/\033\[[0-9;]*m/g.replace(output, '');
	}
}
