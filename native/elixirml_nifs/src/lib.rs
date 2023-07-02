mod matrix;
mod mnist;

#[rustler::nif]
fn mat_rand(rows: u32, cols: u32) -> matrix::Matrix {
  matrix::random(rows as usize, cols as usize)
}

#[rustler::nif]
fn mat_fill(rows: u32, cols: u32, value: f64) -> matrix::Matrix {
  matrix::fill(rows as usize, cols as usize, value)
}

#[rustler::nif]
fn mat_fill_vals(rows: u32, cols: u32, values: Vec<f64>) -> matrix::Matrix {
  matrix::fill_vals(rows as usize, cols as usize, values)
}

#[rustler::nif]
fn mat_sig(mat: matrix::Matrix) -> matrix::Matrix {
  matrix::sig(mat)
}

#[rustler::nif]
fn mat_relu(mat: matrix::Matrix) -> matrix::Matrix {
  matrix::relu(mat)
}

#[rustler::nif]
fn mat_sum(a: matrix::Matrix, b: matrix::Matrix) -> matrix::Matrix {
  matrix::sum(a, b)
}

#[rustler::nif]
fn mat_prod(a: matrix::Matrix, b: matrix::Matrix) -> matrix::Matrix {
  matrix::prod(a, b)
}

#[rustler::nif]
fn mat_shuffle_rows(mat: matrix::Matrix) -> matrix::Matrix {
  matrix::shuffle_rows(mat)
}

rustler::init!(
  "Elixir.ElixirML.NIFs",
  [
    mat_rand,
    mat_fill,
    mat_fill_vals,
    mat_sig,
    mat_relu,
    mat_sum,
    mat_prod,
    mat_shuffle_rows
  ]
);
