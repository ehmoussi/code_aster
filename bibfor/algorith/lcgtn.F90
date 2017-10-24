module lcgtn

implicit none

type gtn_material
    real(kind=8) :: lambda,deuxmu,troisk
    real(kind=8) :: r0,rh,r1,g1,r2,g2,rk,p0,gk
    real(kind=8) :: q1,q2,f0,fc,fr,fn,pn,sn
    real(kind=8) :: vs0,ve0,vm,vd
    real(kind=8) :: c,r
end type gtn_material


end module lcgtn