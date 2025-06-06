// lib/src/features/profile/screens/edit_profile_screen.dart
import 'package:flutter/material.dart';
// import 'dart:io'; // Para File si manejamos selección de imagen local
import 'package:intl/intl.dart';
// import 'package:image_picker/image_picker.dart'; // Importaremos más tarde si añadimos cambio de imagen

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final String currentAvatarPath; // Puede ser local o una URL si lo generalizas
  // Podrías pasar más datos iniciales si los tuvieras
  // final String? currentIdType;
  // final String? currentIdNumber;
  // ... etc.

  const EditProfileScreen({
    Key? key,
    required this.currentName,
    required this.currentEmail,
    required this.currentAvatarPath,
    // this.currentIdType,
    // this.currentIdNumber,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _idNumberController;
  late TextEditingController _birthDateController;
  late TextEditingController _phoneController;

  final _formKey = GlobalKey<FormState>(); // Para validación del formulario

  // Para el futuro manejo de imagen
  // File? _selectedImageFile;
  // String? _newAvatarPath; // Podría ser la ruta del archivo seleccionado o una nueva URL

  // Valores para los Dropdowns y DatePicker
  String? _selectedIdType;
  String? _selectedGender;
  DateTime? _selectedBirthDate;

  final List<String> _idTypes = [
    'Trajeta de Identidad',
    'Cédula de Ciudadanía',
    'Cédula de Extranjería',
    'Pasaporte',
    'NIT',
  ];
  final List<String> _genders = [
    'Masculino',
    'Femenino',
    'Otro',
    'Prefiero no decirlo',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _emailController = TextEditingController(text: widget.currentEmail);
    // Inicializa los nuevos controladores (con valores de ejemplo o vacíos)
    _idNumberController = TextEditingController(
      text: "",
    ); // Ejemplo: widget.currentIdNumber ?? ""
    _birthDateController = TextEditingController(text: "");
    _phoneController = TextEditingController(
      text: "",
    ); // Ejemplo: widget.currentPhoneNumber ?? ""

    // Inicializa los valores seleccionados (si los pasas al widget)
    // _selectedIdType = widget.currentIdType;
    // _selectedGender = widget.currentGender;
    // if (widget.currentBirthDate != null) {
    //   _selectedBirthDate = widget.currentBirthDate;
    //   _birthDateController.text = DateFormat('dd/MM/yyyy').format(_selectedBirthDate!);
    // }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _idNumberController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedBirthDate ??
          DateTime.now().subtract(
            Duration(days: 365 * 18),
          ), // Por defecto 18 años atrás
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Selecciona tu fecha de nacimiento',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
      builder: (context, child) {
        // Para aplicar el tema al DatePicker
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(
                context,
              ).colorScheme.primary, // Color del header
              onPrimary: Theme.of(
                context,
              ).colorScheme.onPrimary, // Color del texto en el header
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(
                  context,
                ).colorScheme.primary, // Color de los botones
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(picked); // Formato dd/MM/yyyy
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Aquí iría la lógica para guardar los datos
      String newName = _nameController.text;
      String newEmail = _emailController.text;
      String idNumber = _idNumberController.text;
      String birthDate = _birthDateController.text;
      String phone = _phoneController.text;

      print('Guardando perfil:');
      print('Nombre: $newName');
      print('Email: $newEmail');
      print('Tipo ID: $_selectedIdType');
      print('Número ID: $idNumber');
      print('Género: $_selectedGender');
      print('Fecha Nacimiento: $birthDate');
      print('Celular: $phone');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Perfil actualizado correctamente'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating, // Para que flote sobre el botón
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, corrige los errores del formulario.'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // --- Placeholder para la selección de imagen ---
  // Future<void> _pickImage() async {
  //   // Lógica para seleccionar imagen usando image_picker
  //   // ...
  //   // setState(() {
  //   //   _selectedImageFile = File(pickedFile.path);
  //   //   _newAvatarPath = pickedFile.path;
  //   // });
  // }

  // ... (dentro de _EditProfileScreenState)

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // QUITAMOS EL BOTÓN DE GUARDAR DEL APPBAR
        // actions: [
        //   TextButton(
        //     onPressed: _saveProfile,
        //     child: Text( /* ... */ ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20.0,
          20.0,
          20.0,
          80.0,
        ), // Más padding abajo para el botón
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // --- SECCIÓN DE IMAGEN DE PERFIL ---
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 65,
                    backgroundColor: colorScheme.primary.withOpacity(0.2),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          widget.currentAvatarPath.startsWith('assets/')
                          ? AssetImage(widget.currentAvatarPath)
                          : NetworkImage(widget.currentAvatarPath)
                                as ImageProvider,
                    ),
                  ),
                  // Botón cambiar imagen (comentado por ahora)
                  // Positioned(...)
                ],
              ),
              const SizedBox(height: 30.0),

              // --- CAMPO NOMBRE ---
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration(
                  labelText: 'Nombre Completo',
                  hintText: 'Ingresa tu nombre',
                  icon: Icons.person_outline_rounded,
                  colorScheme: colorScheme,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Ingresa tu nombre.';
                  if (value.trim().length < 3)
                    return 'Debe tener al menos 3 caracteres.';
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20.0),

              // --- CAMPO EMAIL ---
              TextFormField(
                controller: _emailController,
                decoration: _inputDecoration(
                  labelText: 'Correo Electrónico',
                  hintText: 'Ingresa tu email',
                  icon: Icons.email_outlined,
                  colorScheme: colorScheme,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Ingresa tu correo.';
                  final emailRegex = RegExp(
                    r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  );
                  if (!emailRegex.hasMatch(value))
                    return 'Ingresa un correo válido.';
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20.0),

              // --- TIPO DE IDENTIFICACIÓN (Dropdown) ---
              DropdownButtonFormField<String>(
                value: _selectedIdType,
                items: _idTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedIdType = newValue;
                  });
                },
                decoration: _inputDecoration(
                  labelText: 'Tipo de Identificación',
                  hintText: 'Selecciona un tipo',
                  icon: Icons.badge_outlined,
                  colorScheme: colorScheme,
                ),
                validator: (value) =>
                    value == null ? 'Selecciona un tipo de ID.' : null,
              ),
              const SizedBox(height: 20.0),

              // --- NÚMERO DE IDENTIFICACIÓN ---
              TextFormField(
                controller: _idNumberController,
                decoration: _inputDecoration(
                  labelText: 'Número de Identificación',
                  hintText: 'Ingresa tu número de ID',
                  icon: Icons.onetwothree_rounded,
                  colorScheme: colorScheme,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Ingresa tu número de ID.';
                  if (value.length < 5)
                    return 'Debe tener al menos 5 dígitos.'; // Ajusta según necesidad
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20.0),

              // --- GÉNERO (Dropdown) ---
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: _genders.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                decoration: _inputDecoration(
                  labelText: 'Género',
                  hintText: 'Selecciona tu género',
                  icon: Icons.wc_rounded, // Icono para hombre/mujer
                  colorScheme: colorScheme,
                ),
                // validator: (value) => value == null ? 'Selecciona tu género.' : null, // Opcional
              ),
              const SizedBox(height: 20.0),

              // --- FECHA DE NACIMIENTO (DatePicker) ---
              TextFormField(
                controller: _birthDateController,
                decoration: _inputDecoration(
                  labelText: 'Fecha de Nacimiento',
                  hintText: 'dd/mm/aaaa',
                  icon: Icons.calendar_today_rounded,
                  colorScheme: colorScheme,
                ),
                readOnly:
                    true, // Para que solo se pueda editar con el DatePicker
                onTap: () => _selectBirthDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Selecciona tu fecha de nacimiento.';
                  return null;
                },
              ),
              const SizedBox(height: 20.0),

              // --- NÚMERO DE CELULAR ---
              TextFormField(
                controller: _phoneController,
                decoration: _inputDecoration(
                  labelText: 'Número de Celular',
                  hintText: 'Ej: 3001234567',
                  icon: Icons.phone_android_rounded,
                  colorScheme: colorScheme,
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Ingresa tu número de celular.';
                  if (value.length < 10)
                    return 'Debe tener al menos 10 dígitos.'; // Típico en Colombia
                  return null;
                },
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 40.0), // Espacio antes del botón

              // --- BOTÓN DE GUARDAR (ABAJO) ---
              // Lo añadiremos fuera del SingleChildScrollView, como un FloatingActionButton extendido
              // o dentro de un Stack si quieres que esté siempre visible.
              // Por ahora, lo pondremos aquí para que se desplace con el contenido:
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.4),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.save_alt_rounded,
                    color: colorScheme.onPrimary,
                  ),
                  label: Text('Guardar Cambios'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary, // Fondo naranja
                    foregroundColor: colorScheme.onPrimary, // Letras blancas
                    minimumSize: Size(double.infinity, 55),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    textStyle: textTheme.labelLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 0, // La sombra la da el Container
                  ),
                  onPressed: _saveProfile,
                ),
              ),
              const SizedBox(height: 20.0), // Espacio extra al final del scroll
            ],
          ),
        ),
      ),
      // Si quieres el botón siempre visible abajo, podrías usar esto:
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      //   child: Container( /* ... el mismo Container del botón de arriba ... */),
      // ),
    );
  }

  // Helper para InputDecoration (para no repetir tanto código)
  InputDecoration _inputDecoration({
    required String labelText,
    required String hintText,
    required IconData icon,
    required ColorScheme colorScheme,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(icon, color: colorScheme.primary.withOpacity(0.8)),
      filled: true,
      fillColor: colorScheme.surfaceVariant.withOpacity(
        0.3,
      ), // Un fondo muy sutil
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none, // Sin borde visible por defecto
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
      floatingLabelStyle: TextStyle(
        color: colorScheme.primary,
      ), // Color del label cuando está arriba
    );
  }
}
