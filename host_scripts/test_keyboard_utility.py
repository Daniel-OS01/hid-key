import unittest
import sys
import os

# Add the parent directory to the path so we can import the utility
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from HEBREW_KEYBOARD_UTILITY import HEBREW_QWERTY_MAP

class TestHebrewKeyboardUtility(unittest.TestCase):
    def test_punctuation_mapping(self):
        """
        Tests that the punctuation characters are mapped correctly
        according to the SI-1452 standard.
        """
        self.assertEqual(HEBREW_QWERTY_MAP[','], ',')
        self.assertEqual(HEBREW_QWERTY_MAP['.'], '.')
        self.assertEqual(HEBREW_QWERTY_MAP['/'], 'q')
        self.assertEqual(HEBREW_QWERTY_MAP["'"], "'")
        self.assertEqual(HEBREW_QWERTY_MAP[';'], 'w')

    def test_final_letters_mapping(self):
        """
        Tests that the final forms of Hebrew letters are mapped correctly.
        """
        self.assertEqual(HEBREW_QWERTY_MAP['ם'], 'o')
        self.assertEqual(HEBREW_QWERTY_MAP['ן'], 'i')
        self.assertEqual(HEBREW_QWERTY_MAP['ף'], ';')
        self.assertEqual(HEBREW_QWERTY_MAP['ץ'], '.')
        self.assertEqual(HEBREW_QWERTY_MAP['ך'], 'l')

if __name__ == '__main__':
    unittest.main()
