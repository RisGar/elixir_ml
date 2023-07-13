use libc::c_void;
use rand::Rng;
use rand_distr::{Distribution, StandardNormal};

#[derive(rustler::NifStruct, Debug)]
#[module = "ElixirML.Matrix"]
pub struct Matrix {
  pub rows: usize,
  pub cols: usize,
  pub stride: usize,
  pub nums: Vec<f64>,
}

fn sigmoidf(n: f64) -> f64 {
  1.0 / (1.0 + f64::exp(-n))
}

fn sigmoid_primef(n: f64) -> f64 {
  sigmoidf(n) * (1.0 - sigmoidf(n))
}

const RELU_FACTOR: f64 = 0.01;

fn leaky_reluf(n: f64) -> f64 {
  if n > 0.0 {
    n
  } else {
    RELU_FACTOR * n
  }
}

fn leaky_relu_primef(n: f64) -> f64 {
  if n > 0.0 {
    1.0
  } else {
    RELU_FACTOR
  }
}

pub fn random(rows: usize, cols: usize) -> Matrix {
  let mat_size = rows * cols;

  let mut mat = Matrix {
    rows,
    cols,
    stride: cols,
    nums: Vec::<f64>::with_capacity(mat_size),
  };

  let mut normal = StandardNormal.sample_iter(rand::thread_rng());

  for _ in 0..mat_size {
    mat.nums.push(normal.next().unwrap());
  }

  mat
}

pub fn fill(rows: usize, cols: usize, value: f64) -> Matrix {
  let mat_size = rows * cols;

  Matrix {
    rows,
    cols,
    stride: cols,
    nums: vec![value; mat_size],
  }
}

pub fn fill_vals(rows: usize, cols: usize, vals: Vec<f64>) -> Matrix {
  let mat_size = rows * cols;
  assert!(vals.len() == mat_size);
  Matrix {
    rows,
    cols,
    stride: cols,
    nums: vals,
  }
}

pub fn sig(mut mat: Matrix) -> Matrix {
  for n in mat.nums.iter_mut() {
    *n = sigmoidf(*n);
  }

  mat
}

pub fn relu(mut mat: Matrix) -> Matrix {
  for n in mat.nums.iter_mut() {
    *n = leaky_reluf(*n);
  }

  mat
}

pub fn sum(a: Matrix, b: Matrix) -> Matrix {
  assert!(a.rows == b.rows);
  assert!(a.cols == b.cols);
  let mat_size = a.rows * a.cols;

  let mut mat = Matrix {
    rows: a.rows,
    cols: b.cols,
    stride: b.stride,
    nums: Vec::<f64>::with_capacity(mat_size),
  };

  for i in 0..mat_size {
    mat.nums.push(a.nums[i] + b.nums[i]);
  }

  mat
}

pub fn prod(a: Matrix, b: Matrix) -> Matrix {
  assert!(a.cols == b.rows);
  let mat_size = a.rows * b.cols;

  let mut mat = Matrix {
    rows: a.rows,
    cols: b.cols,
    stride: b.stride,
    nums: vec![0.0; mat_size],
  };

  extern "C" {
    fn cblas_dgemm(
      Order: u32,
      TransA: u32,
      TransB: u32,
      M: i32,
      N: i32,
      K: i32,
      alpha: f64,
      A: *const c_void,
      lda: i32,
      B: *const c_void,
      ldb: i32,
      beta: f64,
      C: *mut c_void,
      ldc: i32,
    );
  }

  unsafe {
    cblas_dgemm(
      101,
      111,
      111,
      a.rows as i32,
      b.cols as i32,
      a.cols as i32,
      1.0,
      a.nums.as_ptr() as *const c_void,
      a.stride as i32,
      b.nums.as_ptr() as *const c_void,
      b.stride as i32,
      0.0,
      mat.nums.as_mut_ptr() as *mut c_void,
      mat.stride as i32,
    );
  }

  mat
}

pub fn shuffle_rows(mut mat: Matrix) -> Matrix {
  for i in 0..mat.rows {
    let mut rng = rand::thread_rng();
    let j: usize = i + rng.gen::<usize>() % (mat.rows - i);

    // let x_i = i * mat.stride;
    // let y_i = j * mat.stride;
    // let x = mat.nums[x_i..x_i + mat.cols].as_mut_ptr() as *mut u32;
    // let y = mat.nums[y_i..y_i + mat.cols].as_mut_ptr() as *mut u32;

    // unsafe {
    //   std::ptr::swap(x, y);
    // }

    for k in 0..mat.cols {
      mat.nums.swap(i * mat.stride + k, j * mat.stride + k);
    }
  }

  mat
}

pub fn batch(mat: Matrix, batch_size: usize) -> Vec<Matrix> {
  assert!(mat.rows % batch_size == 0);
  let batch_amount: usize = mat.rows / batch_size;

  let mut res = Vec::<Matrix>::with_capacity(batch_amount);
  for i in 0..batch_amount {
    let mat = Matrix {
      rows: batch_size,
      cols: mat.cols,
      stride: mat.cols,
      nums: Vec::from_iter(
        mat.nums[i * batch_size * mat.cols..(i + 1) * batch_size * mat.cols]
          .iter()
          .cloned(),
      ),
    };

    res.push(mat)
  }

  res
}
