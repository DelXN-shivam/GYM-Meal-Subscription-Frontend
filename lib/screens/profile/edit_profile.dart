import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController firstNameController = TextEditingController(
    text: 'Jamie',
  );
  TextEditingController lastNameController = TextEditingController(
    text: 'Nelson',
  );
  TextEditingController emailController = TextEditingController(
    text: 'jamienelson12@gmail.com',
  );
  TextEditingController skypeController = TextEditingController(
    text: 'jamieNelson234',
  );
  TextEditingController phoneController = TextEditingController(
    text: '+1-8134258374',
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    skypeController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TabBar(
              controller: _tabController,
              indicatorColor: colorScheme.primary,
              indicatorWeight: 3,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurface.withOpacity(0.5),
              labelStyle: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              tabs: [
                Tab(text: 'General Info'),
                Tab(text: 'Location'),
                Tab(text: 'Settings'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGeneralInfoTab(context, colorScheme, textTheme),
          _buildLocationTab(context, colorScheme, textTheme),
          _buildSettingsTab(context, colorScheme, textTheme),
        ],
      ),
    );
  }

  Widget _buildGeneralInfoTab(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 20),
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=300&fit=crop&crop=face',
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: colorScheme.onPrimary,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  context,
                  'First Name',
                  firstNameController,
                  colorScheme,
                  textTheme,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  context,
                  'Last Name',
                  lastNameController,
                  colorScheme,
                  textTheme,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildTextField(
            context,
            'Email',
            emailController,
            colorScheme,
            textTheme,
            icon: Icons.email_outlined,
          ),
          SizedBox(height: 20),
          // _buildTextField(
          //   'Skype',
          //   skypeController,
          //   icon: Icons.video_call_outlined,
          // ),
          // SizedBox(height: 20),
          _buildTextField(
            context,
            'Phone',
            phoneController,
            colorScheme,
            textTheme,
            icon: Icons.phone_outlined,
          ),
          SizedBox(height: 30),
          _buildChangePasswordButton(context, colorScheme, textTheme),
          SizedBox(height: 30),
          _buildSaveButton(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildLocationTab(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on_outlined,
            color: colorScheme.onSurface.withOpacity(0.5),
            size: 80,
          ),
          SizedBox(height: 20),
          Text(
            'Location Settings',
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onBackground,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Manage your location preferences',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        _buildSettingsItem(
          context,
          'Notifications',
          Icons.notifications_outlined,
          colorScheme,
          textTheme,
        ),
        _buildSettingsItem(
          context,
          'Privacy',
          Icons.lock_outlined,
          colorScheme,
          textTheme,
        ),
        _buildSettingsItem(
          context,
          'Theme',
          Icons.palette_outlined,
          colorScheme,
          textTheme,
        ),
        _buildSettingsItem(
          context,
          'Language',
          Icons.language_outlined,
          colorScheme,
          textTheme,
        ),
        _buildSettingsItem(
          context,
          'Help & Support',
          Icons.help_outline,
          colorScheme,
          textTheme,
        ),
        _buildSettingsItem(
          context,
          'About',
          Icons.info_outline,
          colorScheme,
          textTheme,
        ),
      ],
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    TextEditingController controller,
    ColorScheme colorScheme,
    TextTheme textTheme, {
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              suffixIcon: icon != null
                  ? Icon(
                      icon,
                      color: colorScheme.onSurface.withOpacity(0.5),
                      size: 20,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChangePasswordButton(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return GestureDetector(
      onTap: () {
        // Handle change password
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              'Change Password',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurface.withOpacity(0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          // Handle save
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Icon(Icons.check, color: colorScheme.onPrimary, size: 24),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String title,
    IconData icon,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.onSurface.withOpacity(0.5), size: 24),
          SizedBox(width: 16),
          Text(
            title,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          Icon(
            Icons.chevron_right,
            color: colorScheme.onSurface.withOpacity(0.5),
            size: 20,
          ),
        ],
      ),
    );
  }
}
