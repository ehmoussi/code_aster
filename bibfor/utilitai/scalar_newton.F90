module scalar_newton

implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterc/r8gaem.h"

type newton_state
    aster_logical:: eximin,eximax,ismin,ismax,usemin,usemax
    real(kind=8) :: xmin,xmax,fn
!     real(kind=8),dimension(20):: valx,valf,valdf,bdmin,bdmax,relx
end type newton_state


contains

aster_logical function is_small(df,f)
    real(kind=8)::df,f
    is_small = .false.
    if (abs(df).le.1) then
        is_small = abs(f).gt.r8gaem()*abs(df)
    end if
end function is_small


function utnewt(x,f,df,ite,mem,xmin,xmax,usemin,usemax) result(xnew)

    implicit none

    real(kind=8),intent(in)          :: x
    real(kind=8),intent(in)          :: f
    real(kind=8),intent(in)          :: df
    integer,intent(in)               :: ite
    type(newton_state)               :: mem
    real(kind=8),intent(in),optional :: xmin
    real(kind=8),intent(in),optional :: xmax
    aster_logical,intent(in),optional:: usemin
    aster_logical,intent(in),optional:: usemax
    real(kind=8)                      :: xnew
! ------------------------------------------------------------------------------
!  METHODE DE NEWTON SCALAIRE AVEC CONTROLE DES BORNES ET DICHOTOMIE
!    Condition: fournir des bornes ou une propriete de croissance (f'>0)
!    Si bornes : xmin < xmax et fmin < 0 < fmax
! ------------------------------------------------------------------------------
real(kind=8),parameter::accel=0.5d0
! ------------------------------------------------------------------------------
! ------------------------------------------------------------------------------

    ASSERT(ite.ge.1)
    
    
!   Premier appel : initialisation
    if (ite.eq.1) then
        mem%eximin = present(xmin)
        mem%eximax = present(xmax)
        if (mem%eximin) ASSERT(xmin.le.x)
        if (mem%eximax) ASSERT(x.le.xmax)

        if (mem%eximin) mem%xmin = xmin
        if (mem%eximax) mem%xmax = xmax

        if (present(usemin)) then
            mem%usemin=usemin
        else
            mem%usemin=.true.
        end if

        if (present(usemax)) then
            mem%usemax=usemax
        else
            mem%usemax=.true.
        end if

        mem%ismin = .false.
        if (mem%eximin) mem%ismin = x.eq.xmin

        mem%ismax = .false.
        if (mem%eximax)  mem%ismax = x.eq.xmax

        mem%fn = 0.d0
    end if
    
!     ! Debug
!     mem%valx(ite) = x
!     mem%valf(ite) = f
!     mem%valdf(ite) = df
!     mem%bdmin(ite) = merge(mem%xmin,-r8gaem(),mem%eximin)
!     mem%bdmax(ite) = merge(mem%xmax, r8gaem(),mem%eximax)
!     mem%relx(ite)  = (x-mem%bdmin(1))/(mem%bdmax(1)-mem%bdmin(1))


    if (mem%ismin) ASSERT (mem%usemin)
    if (mem%ismax) ASSERT (mem%usemax)

    if (.not. (mem%eximin .and. mem%eximax)) ASSERT(df.gt.0)
    if (mem%ismin) ASSERT (f.le.0)
    if (mem%ismax) ASSERT (f.ge.0)


    ! Construction des bornes
    if (f.le.0) then
        mem%xmin  = x
        mem%eximin = .true.
        mem%usemin = .false.
    end if

    if (f.ge.0) then
        mem%xmax  = x
        mem%eximax = .true.
        mem%usemax = .false.
    end if


    ! Nouvel itere
    if (df.le.0.d0) then
        ! Fonction decroissante -> Newton sort des bornes -> Dichotomie
        xnew = 0.5d0*(mem%xmin+mem%xmax)
    else if (mem%eximin .and. mem%eximax .and. abs(f).gt.accel*abs(mem%fn) .and. ite.ge.2) then
        ! Gain insuffisant -> Dichotomie
        xnew = 0.5d0*(mem%xmin+mem%xmax)
    else if (is_small(df,f)) then
        ! Derivee presque nulle -> dichotomie si des bornes sont disponibles
        if (mem%eximin .and. mem%eximax) then
            xnew = 0.5d0*(mem%xmin+mem%xmax)
        else
            ! Pas de bornes : hyp. de stricte croissance de la fonction non verifiee
            ASSERT(.false.)
        end if
    else
        ! Methode de Newton
        xnew  = x - f/df
    end if


    ! Stocke la valeur de f courante (pour le calcul du gain)
    mem%fn = f


    ! Projection de x sur les bornes si elles existent
    mem%ismin = .false.
    if (mem%eximin) then
        if (xnew.le.mem%xmin) then
            if (mem%usemin) then
                xnew  = mem%xmin
                mem%ismin = .true.
            else
                xnew = 0.5d0*(mem%xmin+x)
            end if
        end if
    end if

    mem%ismax = .false.
    if (mem%eximax) then
        if (xnew.ge.mem%xmax) then
            if (mem%usemax) then
                xnew  = mem%xmax
                mem%ismax = .true.
            else
                xnew = 0.5d0*(mem%xmax+x)
            end if
        end if
    end if

end function utnewt
        

       
end module scalar_newton