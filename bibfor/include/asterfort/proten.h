interface 
    function proten(u,v) result(w)
    real,dimension(:),intent(in) :: u,v
    real,dimension(size(u),size(v)) :: w    
    end function proten
end interface 