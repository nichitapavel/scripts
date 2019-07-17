import datetime

import pytest

from common import read_timestamp, csv_name_parsing, set_cores
from custom_exceptions import UnsupportedNumberOfCores


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
            {'type': '', 'device': 'hikey970', 'os': 'android', 'benchmark': 'is', 'size': 'b', 'threads': '1', 'iteration': '050'}
        ),
        (
            'data-release_odroidxu4a_linux_mg_b_4_050.csv',
            {'type': '', 'device': 'odroidxu4a', 'os': 'linux', 'benchmark': 'mg', 'size': 'b', 'threads': '4', 'iteration': '050'}
        ),
        (
            'data_rock960_android_mg_b_4_050.csv',
            {'type': '', 'device': 'rock960', 'os': 'android', 'benchmark': 'mg', 'size': 'b', 'threads': '4', 'iteration': '050'}
        ),
        (
            '03_release_data_odroidxu4a_android_is_b_2_108.csv',
            {'type': 'release', 'device': 'odroidxu4a', 'os': 'android', 'benchmark': 'is', 'size': 'b', 'threads': '2', 'iteration': '108'}
        ),
        (
            '03_debug_metrics_hikey970_android_bt_w_2.log',
            {'type': 'debug', 'device': 'hikey970', 'os': 'android', 'benchmark': 'bt', 'size': 'w', 'threads': '2'}
        ),
        (
            'metrics_hikey970_android_bt_s_1.log',
            {'type': '', 'device': 'hikey970', 'os': 'android', 'benchmark': 'bt', 'size': 's', 'threads': '1'}
        )
        # (
        #         'data_odroidxu4a_is_b_2_001',
        #        'TO IMPLEMENTE, SHOULD FAIL, HOW IT SHOULD FAIL? MAYBE JUST RETURN THE DICT WITH EMPTY VALUES (AKA '')'
        # )
    ]
)
def test_csv_name_parsing(name, expected):
    assert csv_name_parsing(name) == expected


# TODO Tests made for a system with 8 cores/threads, how can we mock the result of os.cpu_count() call?
@pytest.mark.parametrize(
    "req_cores, expected",
    [
        (1, 1),
        (6, 6),
        (8, 8),
        (4, 4),
        (None, 6),
    ]
)
def test_set_cores(req_cores, expected):
    assert set_cores(req_cores) == expected


# TODO Tests made for a system with 8 cores/threads, how can we mock the result of os.cpu_count() call?
@pytest.mark.parametrize(
    "req_cores",
    [0, -1, 12]
)
def test_set_cores_exception(req_cores):
    with pytest.raises(UnsupportedNumberOfCores):
        set_cores(req_cores)
