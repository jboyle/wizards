package
{
	import asunit.textui.TestRunner;
	import com.wizards.unittests.AllTests;

	public class WizardsUnitTestRunner extends TestRunner
	{
		public function WizardsUnitTestRunner()
		{
			
			start(AllTests, null, TestRunner.SHOW_TRACE);
		}
		
	}
}