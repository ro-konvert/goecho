package domain.goecho;

import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.app.PendingIntent;
import android.os.PowerManager;
import android.os.PowerManager.WakeLock;

public class GoEchoJava extends org.qtproject.qt5.android.bindings.QtActivity
{
    private static NotificationManager m_notificationManager;
    private static Notification.Builder m_builder;
    private static GoEchoJava m_instance;
	private static PendingIntent contentIntent;
	
	private static final int NOTIFICATION_ID = 5348;

    public GoEchoJava()
    {
		m_instance = this;
    }
	
	public static void powerwakelock()
	{
        PowerManager pm = (PowerManager)m_instance.getSystemService(Context.POWER_SERVICE);
        WakeLock wl = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "GoEchoWakeLock");
		wl.setReferenceCounted(false);
		if((wl != null) && (wl.isHeld() == false))
		{
			wl.acquire();
		}
    }
	
    public static void notifyset(String title, String msg)
    {
        if(m_notificationManager == null)
		{
            m_notificationManager = (NotificationManager)m_instance.getSystemService(Context.NOTIFICATION_SERVICE);
            m_builder = new Notification.Builder(m_instance);
			m_builder.setSmallIcon(R.drawable.icon);
			Intent notificationIntent = new Intent(m_instance, GoEchoJava.class);
			contentIntent = PendingIntent.getActivity(m_instance, 0, notificationIntent, 0);
			m_builder.setAutoCancel(true);
			m_builder.setOngoing(true);
			m_builder.setContentIntent(contentIntent);
        }
		m_builder.setWhen(System.currentTimeMillis());
		m_builder.setContentTitle(title);
		m_builder.setContentText(msg);
        m_notificationManager.notify(NOTIFICATION_ID, m_builder.build());
    }
	
	public static void notifyremove()
	{
		if(m_notificationManager != null)
		{
			m_notificationManager.cancel(NOTIFICATION_ID);
		}
	}
}