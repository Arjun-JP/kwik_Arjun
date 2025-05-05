# Razorpay rules
-keep class com.razorpay.** { *; }
-keep class proguard.annotation.Keep
-keep class proguard.annotation.KeepClassMembers
-keepattributes *Annotation*
-keepclasseswithmembers class * {
    @com.razorpay.* <methods>;
}
-keepclasseswithmembers class * {
    @com.razorpay.* <fields>;
}
-dontwarn com.razorpay.**