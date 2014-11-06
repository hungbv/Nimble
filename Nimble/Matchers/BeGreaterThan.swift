import Foundation

public func beGreaterThan<T: Comparable>(expectedValue: T?) -> NonNilMatcherFunc<T> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "be greater than <\(stringify(expectedValue))>"
        return actualExpression.evaluate() > expectedValue
    }
}

public func beGreaterThan(expectedValue: NMBComparable?) -> NonNilMatcherFunc<NMBComparable> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "be greater than <\(stringify(expectedValue))>"
        let actualValue = actualExpression.evaluate()
        let matches = actualValue != nil && actualValue!.NMB_compare(expectedValue) == NSComparisonResult.OrderedDescending
        return matches
    }
}

public func ><T: Comparable>(lhs: Expectation<T>, rhs: T) {
    lhs.to(beGreaterThan(rhs))
}

public func >(lhs: Expectation<NMBComparable>, rhs: NMBComparable?) {
    lhs.to(beGreaterThan(rhs))
}

extension NMBObjCMatcher {
    public class func beGreaterThanMatcher(expected: NMBComparable?) -> NMBObjCMatcher {
        return NMBObjCMatcher { actualBlock, failureMessage, location in
            let block = ({ actualBlock() as NMBComparable? })
            let expr = Expression(expression: block, location: location)
            let matcher = NonNilMatcherWrapper(NonNilBasicMatcherWrapper(beGreaterThan(expected)))
            return matcher.matches(expr, failureMessage: failureMessage)
        }
    }
}
