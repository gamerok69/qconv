package by.parfen.disptaxi.webapp.app;

import javax.inject.Inject;

import org.apache.wicket.RuntimeConfigurationType;
import org.apache.wicket.authroles.authentication.AbstractAuthenticatedWebSession;
import org.apache.wicket.authroles.authentication.AuthenticatedWebApplication;
import org.apache.wicket.authroles.authorization.strategies.role.annotations.AnnotationsRoleAuthorizationStrategy;
import org.apache.wicket.bean.validation.BeanValidationConfiguration;
import org.apache.wicket.devutils.stateless.StatelessChecker;
import org.apache.wicket.markup.html.WebPage;
import org.apache.wicket.spring.injection.annot.SpringComponentInjector;
import org.apache.wicket.util.lang.Bytes;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

import by.parfen.disptaxi.datamodel.enums.AppRole;
import by.parfen.disptaxi.webapp.home.HomePage;
import by.parfen.disptaxi.webapp.login.LoginPage;
import by.parfen.disptaxi.webapp.orders.OrdersPage;

@Component("wicketWebApplicationBean")
public class WicketWebApplication extends AuthenticatedWebApplication {

	public static final String LOGIN_URL = "/login";

	@Inject
	private ApplicationContext applicationContext;

	/**
	 * @see org.apache.wicket.Application#init()
	 */
	@Override
	public void init() {
		super.init();
		getComponentInstantiationListeners().add(new SpringComponentInjector(this, getApplicationContext()));

		final BeanValidationConfiguration beanValidationConfiguration = new BeanValidationConfiguration();
		beanValidationConfiguration.configure(this);

		getSecuritySettings().setAuthorizationStrategy(new AnnotationsRoleAuthorizationStrategy(this));
		getStoreSettings().setMaxSizePerSession(Bytes.kilobytes(500));
		getStoreSettings().setInmemoryCacheSize(50);
		if (RuntimeConfigurationType.DEPLOYMENT.equals(getConfigurationType())) {
			getDebugSettings().setDevelopmentUtilitiesEnabled(false);
			getDebugSettings().setComponentUseCheck(false);
			getDebugSettings().setAjaxDebugModeEnabled(false);
			getMarkupSettings().setStripComments(true);
			getMarkupSettings().setCompressWhitespace(true);
			getMarkupSettings().setStripWicketTags(true);
		} else {
			getComponentPostOnBeforeRenderListeners().add(new StatelessChecker());
			getDebugSettings().setDevelopmentUtilitiesEnabled(true);
			getDebugSettings().setComponentUseCheck(true);
			getDebugSettings().setAjaxDebugModeEnabled(true);
			getMarkupSettings().setStripComments(false);
			getMarkupSettings().setCompressWhitespace(true);
			getMarkupSettings().setStripWicketTags(true);
		}

		mountPage(LOGIN_URL, LoginPage.class);

	}

	@Override
	protected Class<? extends AbstractAuthenticatedWebSession> getWebSessionClass() {
		return BasicAuthenticationSession.class;
	}

	@Override
	protected Class<? extends WebPage> getSignInPageClass() {
		return LoginPage.class;
	}

	@Override
	public final Class<? extends WebPage> getHomePage() {
		final AppRole userRole = BasicAuthenticationSession.get().getUserAppRole();
		if (userRole == AppRole.ADMIN_ROLE || userRole == AppRole.OPERATOR_ROLE) {
			return OrdersPage.class;
		} else if (userRole == AppRole.CUSTOMER_ROLE || userRole == AppRole.DRIVER_ROLE) {
			// TODO
			// go to currentOrder if extsts
			// else go to neworder.Step1Route
			if (BasicAuthenticationSession.get().getUser() != null) {
				return OrdersPage.class;
			} else {
				return LoginPage.class;
			}
		}
		return HomePage.class;
	}

	public ApplicationContext getApplicationContext() {
		return applicationContext;
	}

}
