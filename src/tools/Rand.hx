package tools;

class Rand {
    public static inline function fifty(x: Float) {
        return (Math.random() * x / 2) + x * .75;
    }

    public static inline function twenty(x: Float) {
        return (Math.random() * x / 5) + x * .9;
    }

    public static inline function perc(x: Float) {
        return Math.random() < x;
    }

    public static inline function list<T>(l: Array<T>) {
        return l[Std.int(Math.random() * l.length)];
    }
}