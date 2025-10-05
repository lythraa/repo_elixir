package taller_entrada_datos;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import javax.swing.JOptionPane;

public class SalarioNeto {
    public static void main(String[] args) {
        try {
            String nombre = JOptionPane.showInputDialog("Nombre del empleado:");
            String horas = JOptionPane.showInputDialog("Horas trabajadas:");
            String valor = JOptionPane.showInputDialog("Valor por hora:");

        
            ProcessBuilder pb = new ProcessBuilder(
                "elixir", "SalarioNeto.exs", nombre, horas, valor
            );
            
            pb.redirectErrorStream(true);
            Process process = pb.start();

            // Leer la respuesta del script
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            StringBuilder resultado = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                resultado.append(line).append("\n");
            }

            // Mostrar el resultado en un JOptionPane
            JOptionPane.showMessageDialog(null, resultado.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
