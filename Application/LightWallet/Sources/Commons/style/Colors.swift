import Foundation
import SwiftUI
import UIKit

public enum Colors {
  public enum Label {
    public static let primary = UIColor(named: "label.primary")!
    public static let secondary = UIColor(named: "label.secondary")!
  }
  public enum System {
    public static let primary = UIColor(named: "system.primary")!
    public static let secondary = UIColor(named: "system.secondary")!
    public static let orange = UIColor(named: "system.orange")!
    public static let red = UIColor(named: "system.red")!
    public static let green = UIColor(named: "system.green")!
    public static let blue = UIColor(named: "system.blue")!
    public static let indigo = UIColor(named: "system.indigo")!
    public static let purple = UIColor(named: "system.purple")!
  }
  public enum Background {
    public static let primary = UIColor(named: "background.primary")!
    public static let secondary = UIColor(named: "background.secondary")!
  }
  public enum Separator {
    public static let transparency = UIColor(named: "separator.transparency")!
    public static let noTransparency = UIColor(named: "separator.noTransparency")!
  }
  public enum Surface {
    public static let overlay = UIColor(named: "surface.overlay")!
  }
  public enum Fill {
    public static let quaternary = UIColor(named: "fill.quaternary")!
  }
}
