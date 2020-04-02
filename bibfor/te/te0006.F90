! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------
!
subroutine te0006(option, nomte)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dilcar.h"
#include "asterfort/epsreg.h"
#include "asterfort/fnoreg.h"
#include "asterfort/regele.h"
#include "asterfort/regini.h"
#include "asterfort/Behaviour_type.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: D_PLAN_2DG
!
! Options: FULL_MECA_*, RIGI_MECA_*, RAPH_MECA
!          CHAR_MECA_PESA_R
!          EPSI_ELGA
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: axi, lSigm, lMatr, lVect
    integer :: i, ivf, ivf2, idfde, idfde2, jgano, ndim, ipoids, npi
    integer :: ipoid2, dimdef, icompo, ichg, ichn, regula(6), idefo
    integer :: icontm, ideplm, ideplp, igeom, imate, jcret, nddls, nddlm
    integer :: imatuu, ivectu, icontp, nno, nnos, nnom, dimuel, dimcon
    integer :: ivarip
!
! --------------------------------------------------------------------------------------------------
!
    lSigm  = L_SIGM(option)
    lMatr  = L_MATR(option)
    lVect  = L_VECT(option)
!
! - Get adresses for fields
!
    call dilcar(option, icompo, icontm, ideplm, ideplp,&
                igeom, imate, imatuu, ivectu, icontp,&
                ivarip, ichg, ichn, jcret, idefo)
! ======================================================================
! --- INITIALISATION DES VARIABLES DE L'ELEMENT ------------------------
! ======================================================================
    call regini(ivf, ivf2, idfde,&
                idfde2, jgano, ndim, ipoids, ipoid2,&
                npi, dimdef, nddls, nddlm, dimcon,&
                dimuel, nno, nnom, nnos,&
                regula, axi)
!
    if (option(1:9) .eq. 'RIGI_MECA') then
        call regele(npi, ndim, dimuel,&
                    nddls, nddlm, nno, nnos, nnom,&
                    axi, regula, dimcon, ipoids, ipoid2,&
                    ivf, ivf2, idfde, idfde2, zk16(icompo),&
                    zr(igeom), zr(ideplm), zr(icontm), zi(imate), dimdef,&
                    zr(imatuu), zr(ivectu), lVect, lMatr, lSigm,&
                    zi(jcret))
    else if (option(1:9).eq.'RAPH_MECA' .or. option(1:9).eq.'FULL_MECA' ) then
        do i = 1, dimuel
            zr(ideplp-1+i)=zr(ideplm-1+i)+zr(ideplp-1+i)
        end do
        call regele(npi, ndim, dimuel,&
                    nddls, nddlm, nno, nnos, nnom,&
                    axi, regula, dimcon, ipoids, ipoid2,&
                    ivf, ivf2, idfde, idfde2, zk16(icompo),&
                    zr(igeom), zr(ideplp), zr(icontp), zi(imate), dimdef,&
                    zr(imatuu), zr(ivectu), lVect, lMatr, lSigm,&
                    zi(jcret))
    else if (option.eq.'FORC_NODA') then
        call fnoreg(dimuel, dimdef, nno, nnos, nnom,&
                    ndim, npi, dimcon, zr(igeom), ipoids,&
                    ipoid2, ivf, ivf2, idfde, idfde2,&
                    nddls, nddlm, axi, regula, zr(ideplm),&
                    zr(icontm), zi(imate), zr(ivectu))
    else if (option.eq.'EPSI_ELGA') then
        call epsreg(npi, ipoids, ipoid2, ivf, ivf2,&
                    idfde, idfde2, zr(igeom), dimdef, dimuel,&
                    ndim, nddls, nddlm, nno, nnos,&
                    nnom, axi, regula, zr(ideplp), zr(idefo))
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
