class Solution:
    def levelOrderBottom(self, root):
        """
        :type root: TreeNode
        :rtype: List[List[int]]
        """
        if root is None:
            return [[]]
        
        if root.left is None and root.right is None:
            return [[root.val]]
            
        if root.left is not None and root.right is None:
            rv = self.levelOrderBottom(root.left)
            rv.append([root.val])
            return rv
            
        if root.left is None and root.right is not None:
            rv = self.levelOrderBottom(root.right)
            rv.append([root.val])
            return rv
            
        rv = self.levelOrderBottom(root.left)
        for index, elem in enumerate(reversed(self.levelOrderBottom(root.right))):
            if index >= len(rv):
                rv.insert(0, elem)
            else:
                rv[index - 1].extend(elem)
            
        rv.append([root.val])
        return rv

class TreeNode:
    def __init__(self, x, left=None, right=None):
        self.val = x
        self.left = left
        self.right = right
    
    def __repr__(self):
        return f"TreeNode(val={self.val}, left={self.left}, right={self.right})"

def tree_from_array(a, i=0):
    if a[i] is None:
        return None

    left_index = 2 * i + 1
    right_index = 2 * i + 2

    left = tree_from_array(a, left_index) if left_index < len(a) else None
    right = tree_from_array(a, right_index) if right_index < len(a) else None

    return TreeNode(a[i], left, right)

def run_test(test, expected):
    s = Solution()
    tree = tree_from_array(test)
    actual = s.levelOrderBottom(tree)
    print(actual)
    assert actual == expected

if __name__ == "__main__":
    run_test([1, 2, 3, 4, None, None, 5], [[4, 5], [2, 3], [1]])
    run_test([0,2,4,1,None,3,-1,5,1,None,6,None,8], [[5,1,6,8],[1,3,-1],[2,4],[0]])