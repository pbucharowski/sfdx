@isTest
public class Foo {
   public static testMethod void testSomething() {
      Account a = null;
   // This is better than having a NullPointerException
   System.assertNotEquals(a, null);
   a.toString();
   }
}
