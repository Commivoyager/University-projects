using System.Collections;
using System.Collections.Generic;

namespace DynamicCollections
{
    public class DynamicList<T> : IEnumerable<T>
    {
        const int StartCapacity = 100;

        public class ArrayWrapper<T>
        {
            public ArrayWrapper(DynamicList<T> list)
            {
                _list = list;
            }
            private DynamicList<T> _list;
            public T this[int index]
            {
                get
                {
                    if (_list.Count <= index || index < 0)
                    {
                        throw new IndexOutOfRangeException("Failed getting value");
                    }
                    return _list._array[index];
                }
                set
                {
                    if (_list.Count <= index || index < 0)
                    {
                        throw new IndexOutOfRangeException("Failed setting value");
                    }
                    _list._array[index] = value;
                }
            }
        }

        private T[] _array;
        //private int _capacity;
        private int _count;
        private ArrayWrapper<T> _arrWrap;

        public int Count
        {
            get { return _count; }
        }

        public ArrayWrapper<T> Items
        {
            get { return _arrWrap; }
        }

        public DynamicList(int startCapacity = StartCapacity)
        {
            _array = new T[startCapacity];
            _count = 0;
            _arrWrap = new ArrayWrapper<T>(this);
        }
        public DynamicList(T[] sourceArr)
        {
            _array = new T[sourceArr.Length];
            _count = 0;
            Array.Copy(sourceArr, _array, sourceArr.Length);
            _arrWrap = new ArrayWrapper<T>(this);
        }

        public void Add(T val)
        {
            if(_array.Length <= _count)
            {
                int oldLen = _array.Length;
                int newLen = oldLen << 1;
                T[] newArr = new T[newLen];
                Array.Copy(_array, newArr, _count);
                _array = newArr;
            }
            _array[_count++] = val;
        }

        public bool Remove()
        {
            if(_count == 0)
            {
                return false;
            }
            _count--;
            // Чтобы отпустить ссылку
            _array[_count] = default!;
            return true;
        }

        public bool Remove(T val)
        {
            int ind = IndexOf(val);
            if(ind < 0)
            {
                return false;
            }
            RemoveAt(ind);
            return true;
        }

        public int IndexOf(T val)
        {
            var comparer = EqualityComparer<T>.Default;
            for(int i = 0; i < _count; i++)
            {
                if (comparer.Equals(_array[i],val))
                {
                    return i;
                }
            }
            return -1;
        }

        public void RemoveAt(int ind)
        {
            if(ind >= _count || ind < 0)
            {
                throw new ArgumentOutOfRangeException("Failed removing value");
            }
            int moveNum = _count - ind - 1;
            if (moveNum > 0)
            {
                Array.Copy(_array, ind+1, _array, ind, moveNum);
            }
            _array[--_count] = default!;
        }

        public void Clear()
        {
            _array = new T[StartCapacity];
            _count = 0;
        }

        public IEnumerator<T> GetEnumerator()
        {
            return new DynamicListEnumerator(this);
        }
        IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
        public struct DynamicListEnumerator : IEnumerator<T>
        {
            //private readonly T[] _array;
            private readonly DynamicList<T> _dList;
            private int _currentInd;
            public DynamicListEnumerator(DynamicList<T> dList)
            {
                //_array = array;
                _dList = dList;
                _currentInd = -1;
            }
            public T Current
            {
                get { return _dList._array[_currentInd]; }
            }
            // чтобы возвращался упакованное значение
            object IEnumerator.Current => Current;
            public bool MoveNext()
            {
                if(++_currentInd < _dList._count)
                {
                    return true;
                }
                return false;
            }
            public void Reset()
            {
                _currentInd = -1;
            }
            public void Dispose() { }
        }
    }
}
