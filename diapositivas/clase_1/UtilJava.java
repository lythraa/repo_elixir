package diapositivas.clase_1;

import java.awt.Component;
import javax.swing.JOptionPane;
/**
 * Clase para utilidades para mostrar mensajes en consola.
 * 
 */
public class UtilJava {
   /**
    * Constructor
    */
   public UtilJava() {
   }

/**
 *  Muestra un mensaje en una ventana emergente.
 *  @param var0 El mensaje a mostrar.
 */
   public static void main(String[] var0) {
      JOptionPane.showMessageDialog((Component)null, var0[0]);
   }
}
