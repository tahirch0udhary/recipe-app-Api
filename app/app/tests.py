
# sample tests

from django.test import SimpleTestCase

from app import calc


class CalcTests(SimpleTestCase):
    # test the calc module

    def test_add_numbers(self):
        # test that two numbers are added together
        res = calc.add(5, 6)
        self.assertEqual(res, 11)

    def test_subtract_number(self):
        # test that values are subtracted and returned
        res = calc.subtract(10, 5)
        self.assertEqual(res, 5)
