using System;
using System.Collections;

namespace BeefMakerEngine
{
    public class ModuleStack : IEnumerable<Module>
    {
        private List<Module> modules = new List<Module>() ~ delete _;

        [Inline] public int Count => modules.Count;

        public ~this()
        {
            for (var m in modules)
                delete m;
        }

        public void Push(Module module)
        {
            modules.Add(module);
            module.OnEnable();
        }

        public void Pop(Module module)
        {
            module.OnDisable();
            modules.Remove(module);
        }

        public List<Module>.Enumerator GetEnumerator()
        {
            return modules.GetEnumerator();
        }
    }
}