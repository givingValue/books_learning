package fitnesse.html;

import fitnesse.responders.run.SuiteResponder;
import fitnesse.wiki.*;

public class SetupTearDownIncluder {
    private PageData pageData;
    private boolean isSuite;
    private WikiPage testPage;
    private StringBuffer newPageContent;
    private PageCrawler pageCrawler; 

    public static String render (PageDate pageData) throws Exception {
        return render (pageData, false);
    }

    public static String render (PageData pageData, boolean isSuite) throws Exception {
        return new SetupTearDownIncluder(pageData).render(isSuite);
    }

    private SetupTearDownIncluder (PageData pageData) {
        this.pageData = pageData;
        this.testPage = pageData.getWikiPage();
        this.pageCrawler = this.testPage.getPageCrawler();
        this.newPageContent = new StringBuffer();
    }

    private String render (boolean isSuite) throws Exception {
        this.isSuite = isSuite;
        if (isTestPage()) {
            includeSetupAndTeardownPages();
        }
        return this.pageData.getHtml();
    }

    private boolean isTestPage () throws Exception {
        return this.pageData.hasAttribute("Test");
    }

    private void includeSetupAndTeardownPages () throws Exception {
        includeSetupPages();
        includePageContent();
        includeTeardownPages();
        updatePageContent();
    }

    private void includeSetupPages () throws Exception {
        if (this.isSuite) {
            includeSuiteSetupPage();
        }
        includeSetupPage();
    }

    private void includeSuiteSetupPage () throws Exception {
        include(SuiteResponder.SUITE_SETUP_NAME, "-setup");
    }

    private void includeSetupPage () throws Exception {
        include("SetUp", "-setup");
    }

    private void includePageContent () throws Exception {
        this.newPageContent.append(this.pageData.getContent());
    }

    private void includeTeardownPages () throws Exception {
        includeTeardownPage();
        if (this.isSuite) {
            includeSuiteTeardownPage();
        }
    }

    private void includeTeardownPage () throws Exception {
        include("TearDown", "-teardown");
    }

    private void includeSuiteTeardownPage () throws Exception {
        include(SuiteResponder.SUITE_TEARDOWN_NAME, "-teardown");
    }

    private void updatePageContent () throws Exception {
        this.pageDate.setContent(this.newPageContent.toString());
    }

    private void include(String pageName, String arg) throws Exception {
        WikiPage inheritedPage = findInheritedPage(pageName);
        if (inheritedPage != null) {
            String pagePathName = getPathNameForPage(inheritedPage);
            buildIncludeDirective(pageName, arg);
        }
    }

    private WikiPage findInheritedPage (String pageName) throws Exception {
        return PageCrawlerImpl.getInheritedPage(pageName, this.testPage);
    }

    private String getPathNameForPage(WikiPage page) throws Exception {
        WikiPagePath pagePath = this.pageCrawler.getFullPath(page);
        return PathParser.render(pagePath);
    }

    private void buildIncludeDirective(String pagePathName, String arg) throws Exception {
        this.newPageContent
            .append("\n!include ")
            .append(arg)
            .append(" .")
            .append(pagePathName)
            .append("\n"); 
    }
}