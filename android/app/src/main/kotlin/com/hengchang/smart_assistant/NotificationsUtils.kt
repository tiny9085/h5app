import android.app.AppOpsManager
import android.content.Context
import android.content.pm.ApplicationInfo
import com.hengchang.smart_assistant.MyApplication
import java.lang.reflect.Field
import java.lang.reflect.InvocationTargetException
import java.lang.reflect.Method

object NotificationsUtils {
    private const val CHECK_OP_NO_THROW = "checkOpNoThrow"
    private const val OP_POST_NOTIFICATION = "OP_POST_NOTIFICATION"
    fun isNotificationEnabled(context: Context): Boolean {
        val mAppOps: AppOpsManager = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val appInfo: ApplicationInfo = context.getApplicationInfo()
        val pkg: String = context.getApplicationContext().getPackageName()
        val uid: Int = appInfo.uid
//        var appOpsClass: Class? = null/* Context.APP_OPS_MANAGER */
        try {
            var appOpsClass = Class.forName(AppOpsManager::class.java.getName())
            val checkOpNoThrowMethod: Method = appOpsClass.getMethod(CHECK_OP_NO_THROW, Integer.TYPE, Integer.TYPE, String::class.java)
            val opPostNotificationValue: Field = appOpsClass.getDeclaredField(OP_POST_NOTIFICATION)
            val value = opPostNotificationValue.get(Integer::class.java) as Int
            return checkOpNoThrowMethod.invoke(mAppOps, value, uid, pkg) as Int == AppOpsManager.MODE_ALLOWED
        } catch (e: ClassNotFoundException) {
            e.printStackTrace()
        } catch (e: NoSuchMethodException) {
            e.printStackTrace()
        } catch (e: NoSuchFieldException) {
            e.printStackTrace()
        } catch (e: InvocationTargetException) {
            e.printStackTrace()
        } catch (e: IllegalAccessException) {
            e.printStackTrace()
        }
        return false
    }
}