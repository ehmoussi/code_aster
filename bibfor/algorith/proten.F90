 function proten(u,v) result(w)
    implicit none
    real,dimension(:),intent(in) :: u,v
    real,dimension(size(u),size(v)) :: w
    integer :: i,j
    do i =1, size(u)
        do j =1, size(v)
            w(i,j) = u(i)*v(j)
        end do
    end do

 end function proten
