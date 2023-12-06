#include <gtk/gtk.h>

int main(int argc, char *argv[]) {
    // Initialize GTK
    gtk_init(&argc, &argv);

    // Create a new window
    GtkWidget *window = gtk_window_new(GTK_WINDOW_TOPLEVEL);

    // Set the window title
    gtk_window_set_title(GTK_WINDOW(window), "Hello World");

    // Set a handler for the delete-event that immediately exits GTK.
    g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);

    // Create a new button
    GtkWidget *button = gtk_button_new_with_label("Hello, World!");

    // When the button receives the "clicked" signal, it will call the function
    // gtk_main_quit() passing NULL as the argument.
    g_signal_connect(button, "clicked", G_CALLBACK(gtk_main_quit), NULL);

    // Add the button to the window
    gtk_container_add(GTK_CONTAINER(window), button);

    // Display the window
    gtk_widget_show_all(window);

    // Start the GTK main loop
    gtk_main();

    return 0;
}
