package io.agora.highqualityaudio.data;

import org.junit.Assert;
import org.junit.Test;

public class SeatTest {
    @Test
    public void TestWindowsClient() {
        Seat seat = new Seat();
        seat.setWindowsClient(true);
        Assert.assertTrue(seat.hasWindowsClient());

        seat.setWindowsClient(false);
        Assert.assertFalse(seat.hasWindowsClient());

        seat.setVacant(true);
        Assert.assertTrue(seat.isVacant());

        seat.setVacant(false);
        Assert.assertFalse(seat.isVacant());

        seat.setMuted(true);
        Assert.assertTrue(seat.isMuted());

        seat.setMuted(false);
        Assert.assertFalse(seat.isMuted());
    }
}
