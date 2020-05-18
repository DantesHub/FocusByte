import Foundation
import Charts

public class IntAxisValueFormatter: NSObject, IAxisValueFormatter {
    var names = [String]()
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\(Int(value))"
    }
    public func setValues(values: [String])
     {
        self.names = values
     }
}
