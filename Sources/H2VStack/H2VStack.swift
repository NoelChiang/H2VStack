// The Swift Programming Language
// https://docs.swift.org/swift-book


import SwiftUI

@available(iOS 16.0, *)
public struct H2VStack: Layout {
    public init() {}
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        // get sizes of each subview
        let sizes = sizes(subviews)
        
        // get container's width
        let horizontalBoundary = proposal.width ?? .infinity
        
        // use to trace current position to put subviews
        var posX = 0.0
        var posY = 0.0
        
        // cache maximum content height at same line
        var cachedLineHeight = 0.0
        
        // flag to define if the subviews' stack is more than one line
        var isMutipleLine = false
        
        // iterate subviews one by one
        sizes.indices.forEach {
            // get subviews' width and height
            let componentWidth = sizes[$0].width
            let componentHeight = sizes[$0].height
            
            // check if current position plus current subview's width is over container's width,
            if posX + componentWidth < horizontalBoundary {
                // -- same line
                
                // accumulate position x with current subview's width
                posX += (componentWidth)
                
                // update line height with larger value
                cachedLineHeight = max(cachedLineHeight, componentHeight)
            } else {
                // -- new line
                
                // move position x to 0 then accomulate with current subview's width
                posX = componentWidth
                
                // accumulate position y with cached line height
                posY += cachedLineHeight
                
                // update line height of current line
                cachedLineHeight = componentHeight
                
                // set multiple line flag to true
                isMutipleLine = true
            }
        }
        
        // result:
        // stack is multiple line -- content's width = container's width
        // stack is single line -- content's width = position x
        let width = isMutipleLine ? horizontalBoundary : posX
        
        // result:
        // content's height = position y plus height of last line
        let height = posY + cachedLineHeight
        
        return CGSize(width: width, height: height)
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        // get sizes of subviews
        let sizes = sizes(subviews)
        
        // assign initial position x and y to container's minimum corner
        var x = bounds.minX
        var y = bounds.minY
        
        // iterate subviews
        subviews.indices.forEach {
            let size = sizes[$0]
            
            // if position x plus subview's width is larger then container's width:
            // move position x to boundary's minimum x
            // accumulate position y with subview's height
            if x + size.width > bounds.maxX {
                x = bounds.minX
                y += size.height
            }
            
            // place subview at position x,y
            subviews[$0].place(
                at: CGPoint(x: x, y: y),
                anchor: .topLeading,
                proposal: ProposedViewSize(
                    width: size.width,
                    height: size.height)
            )
            
            // acculate position x with subview's width
            x += (size.width)
        }
    }
    
    /// Get subviews' size
    private func sizes(_ subviews: Subviews) -> [CGSize] {
        subviews.map({
            $0.sizeThatFits(.unspecified)
        })
    }
    
    /// Get subviews' horizontal space (unused)
    private func hSpaces(_ subviews: Subviews) -> [CGFloat] {
        subviews.indices.map({
            guard $0 < subviews.count - 1 else { return 0.0 }
            return subviews[$0].spacing.distance(to: subviews[$0 + 1].spacing, along: .horizontal)
        })
    }
}
