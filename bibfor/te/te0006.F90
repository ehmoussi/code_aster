! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine te0006(option, nomte)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dilcar.h"
#include "asterfort/epsreg.h"
#include "asterfort/fnoreg.h"
#include "asterfort/regele.h"
#include "asterfort/regini.h"
    character(len=16) :: option, nomte
! ======================================================================
! --- BUT : ROUTINE ELEMENTAIRE DE CALCUL DU MODELE --------------------
! ---       SECOND GRADIENT --------------------------------------------
! ======================================================================
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    aster_logical :: axi
    integer :: i, ivf, ivf2, idfde, idfde2, jgano, ndim, ipoids, npi
    integer :: ipoid2, dimdef, icompo, ichg, ichn, regula(6), idefo
    integer :: icontm, ideplm, ideplp, igeom, imate, jcret, nddls, nddlm
    integer :: imatuu, ivectu, icontp, nno, nnos, nnom, dimuel, dimcon
    integer :: codret, ivarip
    character(len=8) :: typmod(2)
! ======================================================================
! --- INITIALISATION DU CODE RETOUR ------------------------------------
! ======================================================================
    codret = 0
! ======================================================================
! --- RECUPERATION DES ADRESSES DES CHAMPS DE LA CARTE DE L'ELEMENT ----
! ======================================================================
    call dilcar(option, icompo, icontm, ideplm, ideplp,&
                igeom, imate, imatuu, ivectu, icontp,&
                ivarip, ichg, ichn, jcret, idefo)
! ======================================================================
! --- INITIALISATION DES VARIABLES DE L'ELEMENT ------------------------
! ======================================================================
    call regini(option, nomte, ivf, ivf2, idfde,&
                idfde2, jgano, ndim, ipoids, ipoid2,&
                npi, dimdef, nddls, nddlm, dimcon,&
                typmod, dimuel, nno, nnom, nnos,&
                regula, axi)
! ======================================================================
! --- CALCUL ELEMENTAIRE -----------------------------------------------
! ======================================================================
    if (option(1:9) .eq. 'RIGI_MECA') then
        call regele(option, typmod, npi, ndim, dimuel,&
                    nddls, nddlm, nno, nnos, nnom,&
                    axi, regula, dimcon, ipoids, ipoid2,&
                    ivf, ivf2, idfde, idfde2, zk16(icompo),&
                    zr(igeom), zr(ideplm), zr(icontm), zi(imate), dimdef,&
                    zr(imatuu), zr(ivectu))
!
        else if (option(1:9).eq.'RAPH_MECA' .or. option(1:9)&
    .eq.'FULL_MECA' ) then
        do 10 i = 1, dimuel
            zr(ideplp-1+i)=zr(ideplm-1+i)+zr(ideplp-1+i)
 10     continue
        call regele(option, typmod, npi, ndim, dimuel,&
                    nddls, nddlm, nno, nnos, nnom,&
                    axi, regula, dimcon, ipoids, ipoid2,&
                    ivf, ivf2, idfde, idfde2, zk16(icompo),&
                    zr(igeom), zr(ideplp), zr(icontp), zi(imate), dimdef,&
                    zr(imatuu), zr(ivectu))
        zi(jcret) = codret
! ======================================================================
! --- PHASE D'INITIALISATION DU PAS DE TEMPS A PARTIR DE L'INSTANT - ---
! ======================================================================
    else if (option.eq.'FORC_NODA') then
        call fnoreg(dimuel, dimdef, nno, nnos, nnom,&
                    ndim, npi, dimcon, zr(igeom), ipoids,&
                    ipoid2, ivf, ivf2, idfde, idfde2,&
                    nddls, nddlm, axi, regula, zr(ideplm),&
                    zr(icontm), zi(imate), zr(ivectu))
! ======================================================================
! --- OPTION : EPSI_ELGA ------------------------------------------
! ======================================================================
    else if (option.eq.'EPSI_ELGA') then
        call epsreg(npi, ipoids, ipoid2, ivf, ivf2,&
                    idfde, idfde2, zr(igeom), dimdef, dimuel,&
                    ndim, nddls, nddlm, nno, nnos,&
                    nnom, axi, regula, zr( ideplp), zr(idefo))
    else
        ASSERT(.false.)
    endif
! ======================================================================
end subroutine
