@isTest
public class Foo {
   public static testMethod void testSomething() {
      Account a = null;
      String password = "xxxx";
   // This is better than having a NullPointerException
   System.assertNotEquals(a, null);
   a.toString();
   }
}
