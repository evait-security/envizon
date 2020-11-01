Trestle.configure do |config|
  # == Customization Options
  #
  # Set the page title shown in the main header within the admin.
  #
  config.site_title = "envizon"

  # Specify a custom image to be used in place of the site title for mobile and
  # expanded/desktop navigation. These images should be placed within your
  # asset paths, e.g. app/assets/images.
  #
  config.site_logo = "logo/envizon-wide-export-white.svg"

  # Specify a custom image to be used for the collapsed/tablet navigation.
  #
  # config.site_logo_small = "logo-small.png"

  # Speficy a favicon to be used within the admin.
  #
  # config.favicon = "favicon.ico"

  # Set the text shown in the page footer within the admin.
  # Defaults to 'Powered by Trestle'.
  #
  config.footer = "envizon - by evait security GmbH"

  # Sets the default precision for timestamps (either :minutes or :seconds).
  # Defaults to :minutes.
  #
  # config.timestamp_precision = :minutes

  # == Mounting Options
  #
  # Set the path at which to mount the Trestle admin. Defaults to /admin.
  #
  # config.path = "/admin"

  # Toggle whether Trestle should automatically mount the admin within your
  # Rails application's routes. Defaults to true.
  #
  # config.automount = false

  # == Navigation Options
  #
  # Set the path to consider the application root (for title links and breadcrumbs).
  # Defaults to the same value as `config.path`.
  #
  config.root = "/"

  # Set the initial breadcrumbs to display in the breadcrumb trail.
  # Defaults to a breadcrumb labeled 'Home' linking to to the application root.
  #
  # config.root_breadcrumbs = -> { [Trestle::Breadcrumb.new("Home", Trestle.config.root)] }

  # Set the default icon class to use when it is not explicitly provided.
  # Defaults to "fas fa-arrow-circle-o-right".
  #
  # config.default_navigation_icon = "fas fa-arrow-circle-o-right"

  # Add an explicit menu block to be added to the admin navigation.
  #
  # config.menu do
  #   group "Custom Group" do
  #     item "Custom Link", "/admin/custom", icon: "fas fa-car", badge: { text: "NEW!", class: "label-success" }, priority: :first
  #   end
  # end

  # == Extension Options
  #
  # Specify helper modules to expose to the admin.
  #
  # config.helper :all

  # Register callbacks to run before, after or around all Trestle actions.
  #
  # config.before_action do |controller|
  #   Rails.logger.debug("Before action")
  # end
  #
  # config.after_action do |controller|
  #   Rails.logger.debug("After action")
  # end
  #
  # config.around_action do |controller, block|
  #   Rails.logger.debug("Around action (before)")
  #   block.call
  #   Rails.logger.debug("Around action (after)")
  # end

  # Specify a custom hook to be injected into the admin.
  #
  # config.hook(:stylesheets) do
  #   stylesheet_link_tag "custom"
  # end

  # Toggle whether Turbolinks is enabled within the admin.
  # Defaults to true if Turbolinks is available.
  #
  # config.turbolinks = false

  # Specify the parameters that should persist across requests when
  # paginating or reordering. Defaults to [:sort, :order, :scope].
  #
  # config.persistent_params << :query

  # Customize the default adapter class used by all admin resources.
  # See the documentation on Trestle::Adapters::Adapter for details on
  # the adapter methods that can be customized.
  #
  # config.default_adapter = Trestle::Adapters.compose(Trestle::Adapters::SequelAdapter)
  # config.default_adapter.include MyAdapterExtensions

  # Register a form field type to be made available to the Trestle form builder.
  # Field types should conform to the following method definition:
  #
  # class CustomFormField
  #   def initialize(builder, template, name, options={}, &block); end
  #   def render; end
  # end
  #
  # config.form_field :custom, CustomFormField

  # == Debugging Options
  #
  # Enable debugging of form errors. Defaults to true in development mode.
  #
  # config.debug_form_errors = true

  # == Authentication Options
  #
  # Set the authentication backend to use Devise.
  #
  config.auth.backend = :devise

  # Specify the Devise/Warden mapping/scope.
  #
  config.auth.warden.scope = :user

  # Specify the user class to be used by trestle-auth.
  #
  config.auth.user_class = -> { User }

  # Specify the Trestle admin for managing administrator users.
  #
  config.auth.user_admin = -> { :"auth/users" }

  # Customize the rendering of user avatars. Can be disabled by setting to false.
  # Defaults to the Gravatar based on the user's email address.
  #
  # config.auth.avatar = ->(user) {
  #   avatar(fallback: user.initials) do
  #     image_tag(user.avatar_url, alt: user.name) if user.avatar_url?
  #   end
  # }

  # Customize the rendering of the current user's name in the main header.
  # Defaults to the user's #first_name and #last_name (last name in bold),
  # with a fallback to `display(user)` if those methods aren't defined.
  #
  # config.auth.format_user_name = ->(user) {
  #   content_tag(:strong, user.full_name)
  # }

  # Customize the method for determining the user's locale.
  # Defaults to user.locale (if the method is defined).
  #
  # config.auth.locale = ->(user) {
  #   user.locale if user.respond_to?(:locale)
  # }

  # Customize the method for determining the user's time zone.
  # Defaults to user.time_zone (if the method is defined).
  #
  # config.auth.time_zone = ->(user) {
  #   user.time_zone if user.respond_to?(:time_zone)
  # }

  # Specify the redirect location after a successful login.
  # Defaults to the main Trestle admin path.
  #
  # config.auth.redirect_on_login = -> {
  #   if admin = Trestle.lookup(Trestle.config.auth.user_admin)
  #     admin.instance_path(current_user)
  #   else
  #     Trestle.config.path
  #   end
  # }

  # Specify the redirect location after logging out.
  # Defaults to the trestle-auth new login path.
  #
  # config.auth.redirect_on_logout = -> { "/" }

  # Enable or disable the built-in login/logout form and actions. Defaults to true.
  # You may wish to disable these if you are using a custom backend and
  # handling authentication entirely within your main application.
  #
  # config.auth.enable_login = true
  # config.auth.enable_logout = true

  # Specify the path to redirect to when login is required.
  # Defaults to the trestle-auth login page. You may wish to change
  # this if you have also disabled the login form/action above.
  #
  # config.auth.login_url = -> { "/users/sign_in" }

  # Specify the logo used on the login form.
  # If not specified, will fall back to config.site_logo,
  # config.site_logo_small or config.site_title.
  #
  # config.auth.logo = "auth-logo.png"

  # Enable or disable remember me functionality. Defaults to true.
  #
  # config.auth.remember.enabled = false
end
