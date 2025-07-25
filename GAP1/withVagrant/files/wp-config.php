<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'wordpress' );

/** Database password */
define( 'DB_PASSWORD', 'wordpress123' );

/** Database hostname */
define( 'DB_HOST', 'localhost' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'uN:*}W,Rk ELw]UnMI_;^&+UIKd8J&,G;4ga{~=i5{TW4qaPi {qY;j0Y~Elsw=*' );
define( 'SECURE_AUTH_KEY',  '{|XA+/KH>G>t5>I_#MF)DD(7A{V|jgs>7B4.AC&Dt1cvw&9*j/.hi>|xZ47,6{X7' );
define( 'LOGGED_IN_KEY',    'z_)Z?<3.8^DX6HB=]0;lZSCH&ADLDhWJ{IT_lC3@dzK=tp^y}fL(-/] Ve6tJRZ=' );
define( 'NONCE_KEY',        '0F{>#N#~xT!3L$MJ,)}LYP]V0|(TSOh<&LtUT~ixT-@^AcLO9)`$~%@DtHM52fMv' );
define( 'AUTH_SALT',        '{xpKe@(>-fNL6s,}7j`1#z_[t=$=@lvU6EF*EzT@1-!LK%EO~xs40+Db.[~4W-P$' );
define( 'SECURE_AUTH_SALT', 'A&,&0-i42qEROP:Uy:+JkQOO(c8=rCA6|ae=Rt+m4a/[sr/t<nV(?42kPd/#_S(]' );
define( 'LOGGED_IN_SALT',   '>/EW4xCZxdF&2&jM$~J,)lFg&B-A)5Tyi|/dZcQIQZbooj<`~tr*Lr^I_0#0fO]G' );
define( 'NONCE_SALT',       'KRpSvNOm3!oB{XFL4JsnI!KL>PXTb=UNjPV~}o$m7K379_yF26[yi.l(SLBKTZj#' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 *
 * At the installation time, database tables are created with the specified prefix.
 * Changing this value after WordPress is installed will make your site think
 * it has not been installed.
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/#table-prefix
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';

