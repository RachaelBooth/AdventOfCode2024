def bezout_coefficients(a, b)
  if a < b
    gcd, t, s = bezout_coefficients(b, a)
    return gcd, s, t
  end

  r = [a, b]
  q = [0]
  s = [1, 0]
  t = [0, 1]

  i = 1
  loop do
    r.push(r[i - 1] % r[i])
    return r[i], s[i], t[i] if r[i + 1].zero?

    q.push((r[i - 1] - r[i + 1]) / r[i])
    s.push(s[i - 1] - q[i] * s[i])
    t.push(t[i - 1] - q[i] * t[i])
    i += 1
  end
end
