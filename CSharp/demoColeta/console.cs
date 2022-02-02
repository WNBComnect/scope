// (c) Richard Grimes 2003
// Example of getting single character console input
// http://www.ddj.com/windows/184416824

using System;
using System.Runtime.InteropServices;

public
class ConsoleFunctions
{
    // Key press event information
    struct KEY_EVENT_RECORD
    {
        public
        bool    bKeyDown;

        public
        ushort  wRepeatCount,
                wVirtualKeyCode,
                wVirtualScanCode;

        // we'll only process ASCII
        public
        byte    AsciiChar;

        public
        uint    dwControlKeyState;
   }

    // Information about the console input
    struct INPUT_RECORD
    {
        public
        ushort              EventType;

        // Only support key press, the KEY_EVENT_RECORD is the largest
        public
        KEY_EVENT_RECORD    KeyEvent;
    };

    const
    int     ENABLE_PROCESSED_INPUT      = 0x0001,
            ENABLE_ECHO_INPUT           = 0x0004,
            STD_INPUT_HANDLE            = -10,
            STD_OUTPUT_HANDLE           = -11,
            STD_ERROR_HANDLE            = -12;

    const
    ushort  KEY_EVENT                   = 0x0001,
            MOUSE_EVENT                 = 0x0002,
            WINDOW_BUFFER_SIZE_EVENT    = 0x0004,
            MENU_EVENT                  = 0x0008,
            FOCUS_EVENT                 = 0x0010;

    // These are the Win32 Console APIs that we will use
    [DllImport("kernel32")]
    static extern IntPtr GetStdHandle (int type);
    [DllImport("kernel32")]
    static extern bool SetConsoleMode (IntPtr h, uint mode);
    [DllImport("kernel32")]
    static extern bool GetConsoleMode (IntPtr h, out uint mode);
    [DllImport("kernel32")]
    static extern bool ReadConsoleInputA
                            (IntPtr h, out INPUT_RECORD rec, int len, out uint c);

    static
    IntPtr  stdin;

    /** <summary>Get a single character from the console
     * For a more thorough treatment call the CRT getchar()
     * in managed C++, or look at the source code for
     * getchar() supplied with Visual C++.NET</summary>
     * <param name = 'bTilKey'>Indicates the function behaviour:
     * true means 'return only when got a character'. false
     * will check if there's a char, and in the positive
     * case, return this char. In a negative case, return
     * -1 indicating that there's no char available.</param> */
    public static
    int getchar (bool bTilKey)
    {
        INPUT_RECORD    rec;

        int             ch          = -1;

        uint            NumRead/*,
                        oldstate*/;

        if (stdin.ToInt32 () == 0)
            stdin = GetStdHandle (STD_INPUT_HANDLE);

/*        // Save the existing mode
        GetConsoleMode (stdin, out oldstate);

        // Set the mode to character input
        SetConsoleMode (stdin, oldstate);*/

        // Read the console input until we get a single character
        do
        {
//            rec.EventType = 0;
//            rec.KeyEvent.bKeyDown = false;
//            rec.KeyEvent.wRepeatCount = rec.KeyEvent.wVirtualKeyCode = rec.KeyEvent.wVirtualScanCode = 0;
//            rec.KeyEvent.AsciiChar = 0;
//            rec.KeyEvent.dwControlKeyState = 0;

            // Read the next console event
            if ( ! ReadConsoleInputA (stdin, out rec, 1, out NumRead) )
                break;

            // Check that a button was pressed
            if ( ( (rec.EventType & KEY_EVENT) > 0) && rec.KeyEvent.bKeyDown )
                if ( (ch = rec.KeyEvent.AsciiChar) > 0 )
                    break;
        }
        while (bTilKey);

        // Restore the old console mode
//        SetConsoleMode (stdin, oldstate);

        // Return the character
        return ch;
    }
}
