import pytest
import datetime

from common import read_timestamp, csv_name_parsing


@pytest.mark.parametrize(
    "timestamp, ex_timestamp",
    [
        (
                '2019/06/29-16:31:46.3383',
                datetime.datetime(year=2019, month=6, day=29, hour=16, minute=31, second=46, microsecond=338300)
        ),
        (
                '0:00:00.001600',
                datetime.datetime(year=1900, month=1, day=1, microsecond=1600)
        ),
        (
                '0:00:00',
                datetime.datetime(year=1900, month=1, day=1)
        ),
        (
                'not a timestamp',
                None
        )
    ]
)
def test_read_timestamp(timestamp, ex_timestamp):
    assert read_timestamp(timestamp) == ex_timestamp


@pytest.mark.parametrize(
    "name, expected",
    [
        (
                'data-debug_hikey970_android_is_b_1_050.csv',
                {'device': 'hikey970', 'os': 'android', 'benchmark': 'is', 'class': 'b', 'threads': '1'}
        ),
        (
                'data-debug_odroidxu4a_android_bt_w_2_050.csv',
                {'device': 'odroidxu4a', 'os': 'android', 'benchmark': 'bt', 'class': 'w', 'threads': '2'}
        ),
        (
                'data-debug_rock960_android_mg_b_4_050.csv',
                {'device': 'rock960', 'os': 'android', 'benchmark': 'mg', 'class': 'b', 'threads': '4'}
        ),
        (
                'data-release_hikey970_linux_is_b_1_050.csv',
                {'device': 'hikey970', 'os': 'linux', 'benchmark': 'is', 'class': 'b', 'threads': '1'}
        ),
        (
                'data-release_odroidxu4a_linux_bt_w_2_050.csv',
                {'device': 'odroidxu4a', 'os': 'linux', 'benchmark': 'bt', 'class': 'w', 'threads': '2'}
        ),
        (
                'data-release_rock960_linux_mg_b_4_050.csv',
                {'device': 'rock960', 'os': 'linux', 'benchmark': 'mg', 'class': 'b', 'threads': '4'}
        )
    ]
)
def test_csv_name_parsing(name, expected):
    assert csv_name_parsing(name) == expected