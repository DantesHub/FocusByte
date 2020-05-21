import Charts
import Foundation

class PieChartUtil {
    static func createEmptyPieData(len: Int) -> [PieChartDataEntry] {
        var entries = [PieChartDataEntry]()
        for i in (0..<len) {
            entries.append(PieChartDataEntry(value: 0.0, label: ""))
        }
         return entries
     }
    
    
    static func getTagColor(tagTitle: String) -> String {
        for tag in tagDictionary {
            if tagTitle == tag.name {
                return tag.color
            }
        }
        return ""
    }
}
