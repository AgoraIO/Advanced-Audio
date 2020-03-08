package io.agora.advancedaudio.component.annotations;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

@Retention(RetentionPolicy.RUNTIME)
public @interface DisplayActivity {
    String[] SubClasses();
}
