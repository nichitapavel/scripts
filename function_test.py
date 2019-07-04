import pytest
import datetime

from common import read_timestamp


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
